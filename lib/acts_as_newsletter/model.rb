require 'acts_as_newsletter/model/config'
require 'state_machine'

# Module allowing to simply configure a model to be sent as a newsletter
# It can be mixed in an ActiveRecord model by calling the `acts_as_newsletter`
# macro directly in your class' body
#
# @example
#   class Newsletter < ActiveRecord::Base
#     acts_as_newsletter do |newsletter|
#       emails newsletter.emails
#       template_path "emails"
#       template_name "newsletter"
#       layout false
#     end
#   end
#
module ActsAsNewsletter
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      attr_reader :config_proc

      def acts_as_newsletter &config
        # Store config proc to be dynamically run when sending a newsletter
        @config_proc = config

        # Define state machine
        class_eval do
          state_machine :state, initial: :draft do

            event :written do
              transition draft: :ready
            end

            event :ready_canceled do
              transition ready: :draft
            end

            event :prepare_sending do
              transition ready: :sending
            end
            before_transition on: :prepare_sending, do: :prepare_emails

            event :sending_complete do
              transition sending: :sent
            end

            event :cancel do
              transition any => :draft
            end
            after_transition on: :cancel, do: :reset_sending

            state :draft do
              # If readied is set to true, then we transition to the `ready`
              # state so it can be matched when calling `::next_newsletter`
              before_validation do
                written! if readied
              end
            end

            state :ready do
              before_validation do
                ready_canceled! if !readied
              end
            end

            state :sending do
              # When we're sending, saving serializes current emails list
              # to only store remaining recipients and updates sent counter
              #
              before_validation do
                if chunk_sent
                  self.recipients = available_emails.join("|")
                  self.sent_count += emails.length
                  # Transition to :sent state when complete
                  sending_complete! if sent_count >= recipients_count
                end
              end

              # Avoids multiple calls to save to run into the above
              # before_validation hook without the next chunk being really sent
              #
              after_save do
                self.chunk_sent = false if chunk_sent
                @emails = nil
              end
            end

            state :sending, :sent do
              def editable?
                false
              end
            end
          end
        end
      end

      # Send next newsletter if one is ready
      #
      def send_next!
        (newsletter = next_newsletter) && newsletter.send_newsletter!
      end

      # Finds first newsletter being sent or ready
      #
      def next_newsletter
        where(state: :sending).first || where(state: :ready).first
      end
    end

    # Emails chunk size to send at a time
    #
    mattr_accessor :emails_chunk_size
    self.emails_chunk_size = 500

    # Boolean allowing us to know if we sent the last emails chunk
    #
    attr_accessor :chunk_sent

    # Newsletter configuration passed to the block
    def newsletter_config
      @newsletter_config ||=
        Model::Config.new(self, &self.class.config_proc).config
    end

    # Prepare model to handle e-mail sending collecting e-mails and
    # initializing counters
    #
    def prepare_emails
      emails_list = newsletter_config[:emails]
      self.recipients_count = emails_list.length
      self.sent_count = 0
      self.recipients = emails_list.join("|")
    end

    # Parses all available e-mails stored in recpients field
    def available_emails
      @available_emails ||= recipients.split("|")
    end

    # Takes emails from the list and delete them from it
    def emails
      @emails ||= available_emails.shift(emails_chunk_size)
    end

    def editable?
      true
    end

    def reset_sending
      self.recipients_count = 0
      self.sent_count = 0
      self.recipients = ""
      self.readied = false
      save!
    end

    def send_newsletter!
      prepare_sending! if state_name == :ready
      # Get config from newsletter config
      mail_config_keys = [:template_path, :template_name, :layout, :from, :reply_to]
      config = newsletter_config.select do |key, value|
        mail_config_keys.include?(key) and value
      end

      # Send e-mail to each recipient
      emails.each do |email|
        begin
          mail = ActsAsNewsletter::Mailer.newsletter(
            self, email, config, newsletter_config[:before_process]
          )
          # Allows return false or nil in before_process block so the e-mail
          # is not processed
          mail.deliver if mail
        rescue => e
          # Allows to rescue send exceptions
          if ActsAsNewsletter.on_send_exception
            ActsAsNewsletter.on_send_exception.call(e, email, config)
          else
            raise e
          end
        end
      end

      self.chunk_sent = true
      save
    end
  end
end
