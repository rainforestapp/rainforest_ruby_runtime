module RainforestRubyRuntime
  module Variables
    class Registery
      def initialize
        @variables = {}
      end

      def register(variable)
        variables[variable.name] = variable
      end

      def has_variable?(name)
        variables.has_key?(name)
      end

      def [](name)
        variables[name]
      end

      private

      attr_reader :variables
    end

    SCOPE_REGISTRY = Registery.new
  end
end

