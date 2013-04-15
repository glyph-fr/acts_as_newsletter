namespace :acts_as_newsletter do
  desc "Send the next newsletter emails chunk"
  task send_next: :environment do
    if (method = ActsAsNewsletter.send_next)
      method.call
    else
      raise <<-ERROR
You must configure config.send_next Proc to allow this task to be run.
Go to your config/initializers/acts_as_newsletter.rb file and uncomment the
dedicated lines :

config.send_next = proc {
  Newsletter.send_next!
}
ERROR
    end
  end
end
