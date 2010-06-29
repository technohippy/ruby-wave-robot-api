module Waveapi
  class Handler
    attr_reader :filter, :context, :block

    def initialize(opts={}, &block)
      @filter = opts[:filter]
      @context = opts[:context]
      @block = block
    end

    def opt_attrs
      f = @filter ? "filter=\"#{@filter}\" " : ''
      c = @context ? "context=\"#{@context.join(',')}\" " : ''
      f + c
    end

    def call(event, wavelet)
      @block.call(event, wavelet)
      # return op
    end
  end
end
