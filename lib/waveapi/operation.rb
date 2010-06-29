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

    def to_hash
      {
        "id" => @id,
        "method" => @method,
        "params" => params
      }
    end
  end

  class WaveletAppendBlipOperation < Operation
    def initialize(wave_id, message)
      @method = 'wavelet.appendBlip'
      @wave_id = wave_id
      @message = message
    end

    def params
      {
        "waveletId" => "wavesandbox.com!conv+root",
        "waveId" => @wave_id,
        "blipData" => {
          "waveletId" => "wavesandbox.com!conv+root",
          "blipId" => "TBD_wavesandbox.com!conv+root_#{rand}",
          "waveId" => @wave_id,
          "content" => @message,
          "parentBlipId" => nil
        }
      }
    end
  end

  class WaveletSetTitleOperation < Operation
    def initialize
      @method = 'wavelet.setTitle'
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
    def initialize
      @method = 'blip.createChild'
    end
  end

  class BlipDeleteOperation < Operation
    def initialize
      @method = 'blip.delete'
    end
  end

  class DocumentAppendMarkupOperation < Operation
    def initialize
      @method = 'document.appendMarkup'
    end
  end

  class DocumentInlineBlipInsertOperation < Operation
    def initialize
      @method = 'document.inlineBlip.insert'
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
    def initialize(capabilities_hash)
      @queue = [RobotNotifyCapabilitiesHashOperation.new(capabilities_hash)]
    end

    def <<(operation)
      operation.id = "op#{@queue.size + 1}"
    end

    def to_json
      @queue.map{|o| o.to_json}.to_json
      #@queue.to_json
    end
  end
end
