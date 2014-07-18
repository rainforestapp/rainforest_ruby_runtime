module RainforestRubyRuntime
  module Variables
    class Registery
      def initialize(variables = {})
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

    class StaticVariableRegistery
      def initialize(variables)
        @variables = variables.inject({}) do |variables, (name, var_and_values)|
          scope = Scope.new(name)
          var_and_values.each do |name, value|
            scope.define_variable(name.to_sym) { value }
          end
          variables[name] = scope
          variables
        end
      end

      def has_variable?(name)
        @variables.has_key?(name.to_s)
      end

      def [](name)
        @variables[name.to_s]
      end

      def register(*)
        # noop
      end
    end

    def self.scope_registery
      @scope_registery ||= Registery.new
    end

    def self.scope_registery=(registery)
      @scope_registery = registery
    end
  end
end

