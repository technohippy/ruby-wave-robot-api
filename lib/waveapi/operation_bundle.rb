module Waveapi
  class OperationBundle
    attr_accessor :queue, :capabilities_hash, :proxy_for_id

    def initialize(capabilities_hash=nil)
      @queue = capabilities_hash \
        ? [RobotNotifyCapabilitiesHashOperation.new(capabilities_hash)] \
        : []
      @capabilities_hash = capabilities_hash
    end

    def proxy_for(proxy_for_id)
      res = self.new(@capabilities_hash)
      #res.queue = @queue.dup
      res.queue = @queue
      res.proxy_for_id = proxy_for_id
      res
    end

    def <<(operation)
      operation.id = "op#{@queue.size}"
      @queue << operation
    end

    def each(&block)
      @queue.each(&block)
    end

    def to_json
      @queue.to_json
    end
  end
end
