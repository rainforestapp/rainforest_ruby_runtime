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

    def run
      @callback.before_test(self)
      @block.call
      @callback.after_test(self)
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

