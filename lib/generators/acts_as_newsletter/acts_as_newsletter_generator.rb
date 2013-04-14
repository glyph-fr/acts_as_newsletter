require 'rails/generators/active_record'

class ActsAsNewsletterGenerator < ActiveRecord::Generators::Base
  # Copied files come from templates folder
  source_root File.expand_path('../templates', __FILE__)

  # Generator desc
  desc "ActsAsNewsletter install generator"

  def generate_migration
    migration_template "migration.erb", "db/migrate/#{ migration_file_name }"
  end

  def notice
    say " ** Migration created, now just add `acts_as_newsletter` macro to your #{ camelized_model } model"
  end

  private

  def camelized_model
    name.camelize
  end

  def migration_name
    "add_acts_as_newsletter_to_#{ name.pluralize }"
  end

  def migration_file_name
    "#{ migration_name }.rb"
  end

  def migration_class_name
    migration_name.camelize
  end
end
