module RainforestRubyRuntime
  class DSL
    def initialize(callback: )
      @callback = callback
    end

    def test(id: , title: , &block)
      RainforestRubyRuntime::Test.new(id: id, title: title, callback: @callback, &block)
    end

    def define_variable_scope(name, &block)
      scope = Variables::Scope.new(name, &block)
      Variables.scope_registery.register(scope)
    end

    def run_code(code)
      eval(code)
    end
  end
end

