require 'acts_as_newsletter'

module ActsAsNewsletter
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'acts_as_newsletter.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, ActsAsNewsletter::Model)
      end

      ActiveSupport.on_load :action_controller do
        ActsAsNewsletter::Mailer.send(:add_template_helper, ::ApplicationHelper)
      end

      ActiveSupport.on_load :action_view do
        ActionView::Base.send(:include, ActsAsNewsletter::ViewHelper)
      end
    end

    rake_tasks { load "tasks/acts_as_newsletter.rake" }
  end
end