require "tasks/helpers/newsletters_table"

namespace :acts_as_newsletter do
  desc "Send the next newsletter emails chunk"
  task send_next: :environment do
    if (method = ActsAsNewsletter.send_next)
      method.call
    else
      $stderr.puts <<-ERROR
You must configure config.send_next Proc to allow this task to be run.
Go to your config/initializers/acts_as_newsletter.rb file and uncomment the
dedicated lines :

config.send_next = proc {
  Newsletter.send_next!
}
ERROR
      exit(1)
    end
  end

  desc "Check status of newsletters"
  task status: :environment do
    newsletters = Newsletter.order("created_at DESC").all
    table = NewslettersTable.new(newsletters)
    puts table.render
  end

  desc "Unlock a newsletter"
  task unlock: :environment do
    unless ENV['id'].presence
      $stderr.puts "Please set id=<newsletter_id> when calling this task"
      exit(1)
    end

    newsletter = Newsletter.where(id: ENV['id']).first

    unless newsletter
      $stderr.puts "No newsletter with id #{ ENV['id'] } was found"
      exit(1)
    end

    newsletter.update_column(:send_lock, false)

    puts "Newsletter \"#{ newsletter.subject }\" unlocked !"
  end
end
