module ActsAsNewsletter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      # Copied files come from templates folder
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        copy_file "initializer.rb", "config/initializers/acts_as_newsletter.rb"
      end
    end
  end
end