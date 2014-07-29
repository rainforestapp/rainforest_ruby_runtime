module RainforestRubyRuntime
  class Exception < RuntimeError
  end

  class Timeout < RuntimeError
  end

  class WrongReturnValueError < Exception
    attr_reader :returned_value
    def initialize(returned_value)
      @returned_value = returned_value
      super "The script must return a Test object"
    end
  end
end
