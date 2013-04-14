ActsAsNewsletter.config do |config|
  # Allows configuring how many emails are sent in one call to the send
  # action
  #
  # config.model.emails_chunk_size = 500

  # Allows configuring the <From> field for the emails to be sent by.
  # An alternative method is to declare the from field in the
  # `acts_as_newsletter` macro for each instance
  #
  # config.mailer.from = "contact@example.com"

  # Sending logic to be used from the default `acts_as_newsletter:send_next`
  # rake task
  #
  # Here we assume that we have a Newsletter model acting as a newsletter ...
  # Default is a noop
  #
  # config.send_next = proc {
  #   Newsletter.send_next!
  # }
end