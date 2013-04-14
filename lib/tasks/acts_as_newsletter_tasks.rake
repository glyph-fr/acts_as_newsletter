namespace :acts_as_newsletter do
  desc "Send the next newsletter emails chunk"
  task :send_next do
    ActsAsNewsletter.send_next.call
  end
end
