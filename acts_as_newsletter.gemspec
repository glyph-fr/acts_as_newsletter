$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_newsletter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_newsletter"
  s.version     = ActsAsNewsletter::VERSION
  s.authors     = ["Valentin Ballestrino"]
  s.email       = ["vala@glyph.fr"]
  s.homepage    = "http://www.glyph.fr"
  s.summary     = "Allows to send a models content as a batch e-mail to a list"
  s.description = "Allows to send a models content as a batch e-mail to a list"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "state_machine"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "sqlite3"
end
