module RainforestRubyRuntime
  class DSL
    include RSpec::Matchers
    include Capybara::DSL

    def initialize(callback: )
      @callback = callback
    end

    def test(id: , title: , &block)
      RainforestRubyRuntime::Test.new(id: id, title: title, callback: @callback, &block)
    end

    def step(options, &block)
      RainforestRubyRuntime::Step.new(options.merge(callback: @callback), &block).tap(&:run)
    end

    def define_variable_scope(name, &block)
      scope = Variables::Scope.new(name, &block)
      Variables.scope_registry.register(scope)
    end

    def run_code(code)
      eval(code)
    end

    def method_missing(name, *args, &block)
      if Variables.scope_registry.has_variable?(name)
        Variables.scope_registry[name]
      else
        super
      end
    end
  end
end
