module ActsAsNewsletter
  class Mailer < ActionMailer::Base
    # Allows setting a general <From> header by configuring it in the
    # initializer
    #
    cattr_accessor :from

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

      puts "Sending e-mail to #{ email } -- Valid ? #{ valid.inspect }"

      mail mail_config.merge(
        to: email,
        subject: newsletter.subject,
        from: (mail_config[:from] or from)
      ) if valid
    end
  end
end