module RainforestRubyRuntime
  module Variables
    class Scope < Value
      attr_reader :name, :block

      def initialize(*, &block)
        super
        @registry = Registry.new
        instance_eval &block if block_given?
      end

      def define_variable(name, &block)
        @registry.register Value.new(name, &block)
      end

      def method_missing(name, *args, &block)
        if @registry.has_variable?(name)
          @registry[name].call *args, &block
        else
          super
        end
      end
    end
  end
end
