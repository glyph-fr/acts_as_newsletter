require 'spec_helper'
require 'generator_spec/test_case'

require 'generators/acts_as_newsletter/acts_as_newsletter_generator'

describe ActsAsNewsletterGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator %w(test_newsletter)
  end

  it "should create a migration file" do
    assert_migration "db/migrate/add_acts_as_newsletter_to_test_newsletters.rb" do |migration|
      assert_match /class AddActsAsNewsletterToTestNewsletters/, migration
    end
  end
end