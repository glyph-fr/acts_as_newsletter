module ActsAsNewsletter
  mattr_accessor :send_next

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

    def method_missing method, *args, &block
      if ActsAsNewsletter.respond_to?(method)
        ActsAsNewsletter.send(method, *args, &block)
      else
        super method, *args, &block
      end
    end
  end

  def self.config &block
    yield Config.new(&block) if block_given?
  end
end

require 'acts_as_newsletter/model'
require 'acts_as_newsletter/mailer'
require 'acts_as_newsletter/railtie' if defined?(Rails)