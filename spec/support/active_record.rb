unless defined? TestNewsletter
  require 'active_record'

  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

  ActiveRecord::Migration.create_table :test_newsletters do |t|
    t.string :subject
    t.text :content
    t.string :state
    t.text :recipients
    t.integer :recipients_count
    t.integer :sent_count
    t.boolean :readied, default: false
  end

  ActsAsNewsletter::Mailer.from = "contact@example.com"

  EMAILS_CHUNK_SIZE = 2
  RECIPIENTS_COUNT = (2.5 * EMAILS_CHUNK_SIZE).to_i
  RECIPIENTS_EMAILS = RECIPIENTS_COUNT.times.map { |n| "user-#{ n }@example.com" }

  class TestNewsletter < ActiveRecord::Base
    include ActsAsNewsletter::Model

    # Model specific fields
    attr_accessor :subject, :content
    # AcsAsNewsletter created fields
    attr_accessor :state, :recipients, :recipients_count, :sent_count, :readied

    acts_as_newsletter do
      emails model.temp_emails
      # Custom data Hash
      before_process proc {
        data = @email.split('@')
        @data = { name: data.first, domain: data.last }
      }
      # template_name ""
      # template_path ""
      layout false
    end

    def initialize(*)
      super
      send(:initialize_state_machines, :dynamic => :force)
    end

    def temp_emails
      RECIPIENTS_EMAILS
    end
  end
end