module RainforestRubyRuntime
  module DSL
    def test(id: , title: , &block)
      RainforestRubyRuntime::Test.new(id: id, title: title, &block)
    end

    def define_variable_scope(name, &block)
      scope = Variables::Scope.new(name, &block)
      Variables.scope_registery.register(scope)
    end
  end
end

