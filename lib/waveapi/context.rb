require 'waveapi/message_bundle'
require 'waveapi/operation'

module Waveapi
  class Context
    attr_accessor :message_bundle, :operation_bundle

    def initialize(json_str='', capabilities_hash=nil)
      @raw_json = json_str
      @capabilities_hash = capabilities_hash
      MessageBundle.new(json_str, self)
      @operation_bundle = OperationBundle.new(capabilities_hash)
    end

=begin
    def proxy_for(proxy_for_id)
      self.class.new(@message_bundle, @operation_bundle.proxy_for(proxy_for_id))
    end
=end
    def address_for_proxy(proxy_for_id)
      @message_bundle.robot_address.sub('@', "+#{proxy_for_id}@")
    end

    def domain
      @domain ||= @message_bundle.wavelet.domain
    end

    def blips
      @message_bundle.blips
    end

    def find_blip_by_id(blip_id)
      @message_bundle.blips[blip_id]
    end

    def add_blip(blip)
      @message_bundle.blips[blip.blip_id] = blip
    end

    def add_operation(operation)
      @operation_bundle << operation
    end

    def copy
      self.class.new(@raw_json, @capabilities_hash)
    end
  end
end
