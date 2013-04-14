require 'spec_helper'
require 'generator_spec/test_case'

require 'generators/acts_as_newsletter/install/install_generator'

describe ActsAsNewsletter::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator
  end

  it "should create an initializer file" do
    assert_file "config/initializers/acts_as_newsletter.rb"
  end
end