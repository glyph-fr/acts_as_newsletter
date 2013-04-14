module ActsAsNewsletter
  module Model
    class Config
      attr_reader :config

      def initialize &block
        # Initialize config default values
        @config = { emails: [], layout: false }
        # Eval block to edit config
        instance_eval &block if block_given?
      end

      %w(emails template_path template_name layout from).each do |method|
        define_method method do |value|
          @config[method.to_sym] = value
        end
      end
    end
  end
end