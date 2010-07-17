module Waveapi
  class WaveService
    def initialize(use_sandbox=false, server_rpc_base=nil, consumer_key='anonymous', consumer_secret='anonymous')
      # TODO
      @context = Context.new
    end

    def self.new_blip_data(wave_id, wavelet_id, initial_content='', parent_blip_id=nil)
      temp_blip_id = "TBD_#{wavelet_id}_#{rand(1000000).to_s(16)}"
      {
        'waveId' => wave_id,
        'waveletId' => wavelet_id,
        'blipId' => temp_blip_id,
        'content' => initial_content,
        'parentBlipId' => parent_blip_id
      }
    end

    def self.new_wavelet_data(domain, participants)
      wave_id = "#{domain}!TBD_#{rand(1000000).to_s(16)}"
      wavelet_id = "#{domain}!conv+root"
      root_blip_data = new_blip_data(wave_id, wavelet_id)
      wavelet_data = {
        'waveId' => wave_id,
        'waveletId' => wavelet_id,
        'rootBlipId' => root_blip_data['blipId'],
        'participants' => participants.participants
      }
      [root_blip_data, wavelet_data]
    end

    def new_wave(domain, participants=[], message='', proxy_for_id=nil, submit=false)
      # TODO: check if valid proxy for id

      case message
      when String; # do nothing
      when Hash;   message = message.to_json
      when JSON;   message = message.to_s
      else;        raise ArgumentError.new('Invalid message type')
      end
      blip_data, wavelet_data = self.class.new_wavelet_data(domain, participants)
      operation = RobotCreateWaveletOperation.new(wavelet_data['waveId'], 
        wavelet_data['waveletId'], wavelet_data, message)
      @context.add_operation(operation)
      root_blip = Blip.new(blip_data, @context)
      @context.add_blip(root_blip)
      created_wavelet = Wavelet.new(wavelet_data, @context)
      if submit
        # TODO
      end
      created_wavelet
    end
  end
end
