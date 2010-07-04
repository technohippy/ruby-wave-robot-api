module Waveapi
  class Context
    attr_reader :message_bundle, :operation_bundle

    def initialize(message_bundle, operation_bundle)
      @message_bundle = message_bundle
      @operation_bundle = operation_bundle
    end

    def proxy_for(proxy_for_id)
      self.class.new(@message_bundle, @operation_bundle.proxy_for(proxy_for_id))
    end

    def blips
      @message_bundle.blips
    end

    def find_blip_by_id(blip_id)
      blips.find{|b| b.id == blip_id}
    end

    def add_blip(blip)
      @message_bundle.blips << blip
    end

    def add_operation(operation)
      @operation_bundle << operation
    end
  end
end
