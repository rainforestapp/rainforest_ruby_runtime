module RainforestRubyRuntime
  module DSL
    def test(id: , title: , &block)
      RainforestRubyRuntime::Test.new(id: id, title: title, &block)
    end
  end
end

