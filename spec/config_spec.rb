require 'spec_helper'

describe ActsAsNewsletter do
  it "should yield configuration when ::config class method is called" do
    ActsAsNewsletter.config do |config|
      config.class.should be ActsAsNewsletter::Config
    end
  end

  it "should allow configuring the mailer" do
    ActsAsNewsletter.config do |config|
      config.mailer.from = "contact@example.com"
    end
    ActsAsNewsletter::Mailer.from.should eq "contact@example.com"
  end

  it "should allow configuring the model mixin" do
    ActsAsNewsletter.config do |config|
      config.model.emails_chunk_size = EMAILS_CHUNK_SIZE
    end
    ActsAsNewsletter::Model.emails_chunk_size.should eq EMAILS_CHUNK_SIZE
  end
end