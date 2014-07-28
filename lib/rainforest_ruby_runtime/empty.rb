module RainforestRubyRuntime
  class Empty
    def method_missing(*)
      nil
    end
  end
end
