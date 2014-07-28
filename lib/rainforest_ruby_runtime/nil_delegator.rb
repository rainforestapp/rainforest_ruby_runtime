module RainforestRubyRuntime
  class NilDelegator
    def initialize(object)
      @object = object
    end

    def method_missing(meth, *args, &block)
      if @object.respond_to?(meth)
        @object.public_send(meth, *args, &block)
      end
    end
  end
end

