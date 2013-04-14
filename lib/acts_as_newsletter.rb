module ActsAsNewsletter
  class Config
    # Define classes config accessors
    %w(model mailer).each do |method|
      define_method(method) do
        ActsAsNewsletter.const_get(method.camelize)
      end
    end

    def initialize &block
      block.call(self) if block_given?
    end
  end

  def self.config &block
    yield Config.new(&block) if block_given?
  end
end

require 'acts_as_newsletter/model'
require 'acts_as_newsletter/mailer'
