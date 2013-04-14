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
end