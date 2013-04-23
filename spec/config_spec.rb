require 'spec_helper'

describe ActsAsNewsletter::Model::Config do
  before do
    @newsletter = TestNewsletter.new
    ActsAsNewsletter::Mailer.stub(:mail)
  end

  it "contains before_process filter as an instance_eval'ed lambda" do
    @email = "test@email.com"
    instance_eval &@newsletter.newsletter_config[:before_process]
    @data.should eq({ name: 'test', domain: 'email.com' })
  end
end