require 'acts_as_newsletter'

module ActsAsNewsletter
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'acts_as_newsletter.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, ActsAsNewsletter::Model)
      end
    end

    rake_tasks { load "tasks/acts_as_newsletter.rake" }
  end
end