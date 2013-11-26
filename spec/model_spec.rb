require 'spec_helper'

describe TestNewsletter do
  before(:each) do
    # Empty deliveries
    ActionMailer::Base.deliveries = []
    # Ensure config specs doesn't edit current chunks size
    ActsAsNewsletter::Model.emails_chunk_size = EMAILS_CHUNK_SIZE
    @newsletter = TestNewsletter.new
  end

  it "should be initialized as a draft" do
    @newsletter.draft?.should be_true
  end

  it "should transition to ready state when readied switch is set to true" do
    @newsletter.readied = true
    @newsletter.save
    @newsletter.state_name.should eq :ready
  end

  it "should transition back to draft state if readied is set to false" do
    @newsletter.readied = true
    @newsletter.save
    @newsletter.readied = false
    @newsletter.save
    @newsletter.state_name.should eq :draft
  end

  it "should prepare sending when #send_newsletter! is called" do
    @newsletter.readied = true
    @newsletter.save
    @newsletter.send_newsletter!
    @newsletter.emails.length.should eq EMAILS_CHUNK_SIZE
  end

  it "should prepare recipients when asked to" do
    @newsletter.readied = true
    @newsletter.save
    @newsletter.prepare_sending!
    @newsletter.state_name.should eq :sending
    @newsletter.emails.should include("user-0@example.com")
    @newsletter.emails.length.should eq EMAILS_CHUNK_SIZE
    @newsletter.sent_count.should eq 0
    @newsletter.recipients_count.should eq RECIPIENTS_COUNT
  end

  context "Sending" do
    before(:each) do
      @newsletter.readied = true
      @newsletter.save
      @newsletter.prepare_sending!
    end

    context "emails" do
      it "should contain the next recipients to send emails to" do
        @newsletter.emails.should eq RECIPIENTS_EMAILS.take EMAILS_CHUNK_SIZE
      end

      it "should contain different emails on each sending" do
        first_emails = @newsletter.emails
        @newsletter.send_newsletter!
        second_emails = @newsletter.emails
        second_emails.should_not eq first_emails
      end
    end

    it "should update sent emails counter when a chunk is sent" do
      expected_recipients = @newsletter.emails
      @newsletter.send_newsletter!
      @newsletter.sent_count.should eq EMAILS_CHUNK_SIZE

      actual_recipients = ActionMailer::Base.deliveries.map(&:to).flatten
      expected_recipients.should eq actual_recipients
    end

    it "should send to all recipients and transition to :sent state when called enough times" do
      expected_recipients = @newsletter.available_emails.dup
      3.times { @newsletter.send_newsletter! }
      @newsletter.sent_count.should eq RECIPIENTS_COUNT

      @newsletter.state_name.should eq :sent

      actual_recipients = ActionMailer::Base.deliveries.map(&:to).flatten
      actual_recipients.should eq expected_recipients
    end

    context "before process block" do
      it "can return false so e-mail is not sent" do
        @newsletter.newsletter_config[:before_process] = proc { false }
        @newsletter.send_newsletter!
        ActionMailer::Base.deliveries.length.should eq 0
      end
    end

    context "#send_newsletter!", focus: true do
      it "sends one email per recipient" do
        expect(ActsAsNewsletter::Mailer).to receive(:newsletter)
          .exactly(EMAILS_CHUNK_SIZE).times

        @newsletter.send_newsletter!
      end

      it "locks sending on the newsletter while sending" do
        expect(@newsletter).to receive(:lock_sending)

        @newsletter.send_newsletter!
      end

      it "unlocks sending on the newsletter while sending" do
        expect(@newsletter).to receive(:unlock_sending)

        @newsletter.send_newsletter!
      end
    end

    context "#lock_sending", focus: true do
      it "marks the newsletter as locked" do
        @newsletter.lock_sending
        @newsletter.reload.send_lock.should eq true
      end
    end

    context "#unlock_sending", focus: true do
      it "marks the newsletter as unlocked" do
        @newsletter.lock_sending
        @newsletter.unlock_sending
        @newsletter.reload.send_lock.should eq false
      end
    end
  end
end
