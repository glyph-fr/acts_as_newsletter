module ActsAsNewsletter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      # Copied files come from templates folder
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        copy_file "initializer.rb", "config/initializers/acts_as_newsletter.rb"
      end

      def copy_translations
        copy_file "locales/acts_as_newsletter.fr.yml", "config/locales/acts_as_newsletter.fr.yml"
        copy_file "locales/acts_as_newsletter.en.yml", "config/locales/acts_as_newsletter.en.yml"
      end
    end
  end
end