module ActsAsNewsletter
  class Mailer < ActionMailer::Base
    # Allows setting a general <From> header by configuring it in the
    # initializer
    #
    cattr_accessor :from

    # Sends the actual newsletter to the specified email
    #
    def newsletter newsletter, email, mail_config, before_process
      @newsletter = newsletter
      @email = email

      # Custom before_process to be processed here
      instance_eval &before_process if before_process

      mail mail_config.merge(
        to: email,
        subject: newsletter.subject,
        from: (mail_config[:from] or from)
      )
    end
  end
end