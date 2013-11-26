module ActsAsNewsletter
  class Mailer < ActionMailer::Base
    # Allows setting a general <From> header by configuring it in the
    # initializer
    #
    cattr_accessor :from, :reply_to

    class << self
      def template_helpers=(helpers)
        ActiveSupport.on_load :action_controller do
          helpers.each do |helper|
            ActsAsNewsletter::Mailer.send(:add_template_helper, helper.constantize)
          end
        end
      end
    end

    # Sends the actual newsletter to the specified email
    #
    def newsletter newsletter, email, mail_config, before_process
      @newsletter = newsletter
      @email = email

      # Custom before_process to be processed here
      valid = before_process ? instance_eval(&before_process) : true

      return unless valid

      # Prepare #mail hash argument
      params = mail_config.merge(to: email, subject: newsletter.subject)

      # Add from and reply_to params
      params[:from] ||= from
      params[:reply_to] ||= reply_to || params[:from]

      # Prepare e-mail
      mail(params)
    end
  end
end