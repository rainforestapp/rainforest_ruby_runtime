module RainforestRubyRuntime
  class Test
    attr_reader :id, :title, :steps

    def initialize(id: , title: , callback: , &block)
      @id = id
      @title = title
      @steps = []
      @block = block
      @callback = callback
    end

    def step(options, &block)
      step = Step.new(options.merge(callback: @callback), &block)
      @steps << step
      step.run
      step
    end

    def run
      extend RSpec::Matchers
      extend Capybara::DSL
      @callback.before_test(self)
      instance_eval &@block
      @callback.after_test(self)
    end

    def method_missing(name, *args, &block)
      if Variables.scope_registery.has_variable?(name)
        Variables.scope_registery[name]
      else
        super
      end
    end
  end

  class Step
    attr_reader :id, :action, :response

    def initialize(id: , action: , response: , callback: , &block)
      @id = id
      @action = action
      @response = response
      @block = block
      @callback = callback
    end

    def run
      @callback.before_step(self)
      @block.call
      @callback.after_step(self)
    end
  end
end

