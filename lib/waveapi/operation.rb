require 'json'

module Waveapi
  # Operation Types
  WAVELET_APPEND_BLIP = 'wavelet.appendBlip'
  WAVELET_SET_TITLE = 'wavelet.setTitle'
  WAVELET_ADD_PARTICIPANT = 'wavelet.participant.add'
  WAVELET_DATADOC_SET = 'wavelet.datadoc.set'
  WAVELET_MODIFY_TAG = 'wavelet.modifyTag'
  WAVELET_MODIFY_PARTICIPANT_ROLE = 'wavelet.modifyParticipantRole'
  BLIP_CREATE_CHILD = 'blip.createChild'
  BLIP_DELETE = 'blip.delete'
  DOCUMENT_APPEND_MARKUP = 'document.appendMarkup'
  DOCUMENT_INLINE_BLIP_INSERT = 'document.inlineBlip.insert'
  DOCUMENT_MODIFY = 'document.modify'
  ROBOT_CREATE_WAVELET = 'robot.createWavelet'
  ROBOT_FETCH_WAVE = 'robot.fetchWave'
  ROBOT_NOTIFY_CAPABILITIES_HASH = 'robot.notifyCapabilitiesHash'

  class Operation
    attr_accessor :id

    def new_blip_data(wave_id, wavelet_id, initial_content, parent_blip_id)
      temp_blip_id = "TBD_#{wavelet_id}_#{rand(100000).to_s(16)}"
      {
        'waveId' => wave_id,
        'waveletId' => wavelet_id,
        'blipId' => temp_blip_id,
        'content' => initial_content,
        'parentBlipId' => parent_blip_id
      }
    end

    def to_hash
      {
        "id" => @id,
        "method" => @method,
        "params" => params
      }
    end

    def to_json
      self.to_hash.to_json
    end
  end

  class WaveletAppendBlipOperation < Operation
    def initialize(wave_id, message)
      @method = 'wavelet.appendBlip'
      @wave_id = wave_id
      @wavelet_id = 'wavesandbox.com!conv+root'
      @message = message
      @blip_data = new_blipdata(@wave_id, @wavelet_id, @message, nil)
    end

    def params
      {
        "waveletId" => @wavelet_id,
        "waveId" => @wave_id,
        "blipData" => @blip_data
      }
    end
  end

  class WaveletSetTitleOperation < Operation
    def initialize(wave_id, title)
      @method = 'wavelet.setTitle'
      @wave_id = wave_id
      @title = title
    end

    def params
      {
        "waveletId" => "wavesandbox.com!conv+root",
        "waveId" => @wave_id,
        "waveletTitle" => @title
      }
    end
  end

  class WaveletAddParticipantOperation < Operation
    def initialize
      @method = 'wavelet.participant.add'
    end
  end

  class WaveletDatadocSetOperation < Operation
    def initialize
      @method = 'wavelet.datadoc.set'
    end
  end

  class WaveletModifyTagOperation < Operation
    def initialize
      @method = 'wavelet.modifyTag'
    end
  end

  class WaveletModifyParticipantRoleOperation < Operation
    def initialize
      @method = 'wavelet.modifyParticipantRole'
    end
  end

  class BlipCreateChildOperation < Operation
    attr_reader :blip_data

    def initialize(wave_id, wavelet_id, parent_blip_id)
      @method = 'blip.createChild'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @blip_data = new_blipdata(wave_id, wavelet_id, '', parent_blip_id)
    end

    def params
      {
        "waveletId" => @wavelet_id,
        "waveId" => @wave_id,
        "blipData" => @blip_data
      }
    end
  end

  class BlipDeleteOperation < Operation
    def initialize
      @method = 'blip.delete'
    end
  end

  class DocumentAppendMarkupOperation < Operation
    def initialize(wave_id, wavelet_id, blip_id, content)
      @method = 'document.appendMarkup'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @blip_id = blip_id
      @content = content
    end

    def params
      {
        'waveId' => @wave_id,
        'waveletId' => @wavelet_id,
        'blipId' => @blip_id,
        'content' => @content
      }
    end
  end

  class DocumentInlineBlipInsertOperation < Operation
    attr_reader :inline_blip_data

    def initialize(wave_id, wavelet_id, parent_blip_id, position)
      @method = 'document.inlineBlip.insert'
      @inline_blip_data = new_blipdata(wave_id, wavelet_id, '', blip_id)
      @position = position
    end

    def params
      {
        'waveId' => @wave_id,
        'waveletId' => @wavelet_id,
        'blipId' => @blip_id,
        'index' => @positioin,
        'blipData' => @inline_blip_data
      }
    end
  end

  class DocumentModifyOperation < Operation
    def initialize
      @method = 'document.modify'
    end
  end

  class RobotCreateWaveletOperation < Operation
    def initialize
      @method = 'robot.createWavelet'
    end
  end

  class RobotFetchWaveOperation < Operation
    def initialize
      @method = 'robot.fetchWave'
    end
  end

  class RobotNotifyCapabilitiesHashOperation < Operation
    def initialize(capabilities_hash)
      @id = '0'
      @method = 'robot.notifyCapabilitiesHash'
      @capabilities_hash = capabilities_hash
    end

    def params
      {
        "capabilitiesHash" => @capabilities_hash,
        "protocolVersion" => "0.21"
      }
    end
  end

  class OperationBundle
    attr_accessor :queue, :capabilities_hash, :proxy_for_id

    def initialize(capabilities_hash)
      @queue = [RobotNotifyCapabilitiesHashOperation.new(capabilities_hash)]
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
      puts ">>>>> OperationBundle.<<"
      operation.id = "op#{@queue.size + 1}"
      @queue << operation
    end

    def to_json
      @queue.to_json
    end
  end
end
