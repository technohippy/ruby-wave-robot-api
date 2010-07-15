module Waveapi
  class WaveService
    def initialize(use_sandbox=false, server_rpc_base=nil, consumer_key='anonymous', consumer_secret='anonymous')
      # TODO
    end

    def new_wave(domain, participants=[], message='', proxy_for_id=nil, submit=false)
      # check if valid proxy for id

      context = Context.new

      case message
      when String
        # do nothing
      when Hash
        message = JSON.gemerate(message).to_s
      when JSON
        message = message.to_s
      else
        raise ArgumentError.new('Invalid message type')
      end
    end
  end
end
