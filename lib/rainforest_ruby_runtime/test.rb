module RainforestRubyRuntime
  class Test
    attr_reader :id, :title, :steps

    def initialize(id: , title: , &block)
      @id = id
      @title = title
      @steps = []
      @block = block
    end

    def step(**args, &block)
      step = Step.new(**args, &block)
      @steps << step
      step.run
      step
    end

    def run
      extend RSpec::Matchers
      extend Capybara::DSL
      instance_eval &@block
    end

    def method_missing(name, *args, &block)
      if Variables::SCOPE_REGISTRY.has_variable?(name)
        Variables::SCOPE_REGISTRY[name]
      else
        super
      end
    end
  end

  class Step
    attr_reader :id, :action, :response

    def initialize(id: , action: , response: , &block)
      @id = id
      @action = action
      @response = response
      @block = block
    end

    def run
      @block.call
    end
  end
end

