module ActsAsNewsletter
  module Model
    class Config
      attr_reader :config, :model

      def initialize model, &block
        # Initialize config default values
        @config = { emails: [], layout: false }
        @model = model
        # Eval block to edit config
        instance_exec(model, &block) if block_given?
      end

      %w(emails before_process template_path template_name layout from reply_to).each do |method|
        define_method method do |value|
          @config[method.to_sym] = value
        end
      end
    end
  end
end