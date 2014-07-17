module RainforestRubyRuntime
  module Variables
    class Value
      attr_reader :name, :block

      def initialize(name, &block)
        @name = name
        @block = block
      end

      def call(*args, &block)
        @block.call *args, &block
      end
    end
  end
end

