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

    def domain
      @wave_id.split('!').first
    end

    def to_hashmap
      {
        "id" => @id,
        "method" => @method,
        "params" => params
      }
    end

    def to_json
      self.to_hashmap.to_json
    end
  end

  class WaveletAppendBlipOperation < Operation
    def initialize(wave_id, context, message=nil, proxy_for_id=nil)
      @method = 'wavelet.appendBlip'
      @wave_id = wave_id
      @context = context
      @wavelet_id = "#{@context.domain}!conv+root"
      @message = message || "\n"
      @proxy_for_id = proxy_for_id
      @blip_data = WaveService.new_blip_data(@wave_id, @wavelet_id, @message, nil)
    end

    def blip
      unless @blip
        @blip = Blip.new(@blip_data, @context)
        @blip.proxy_for_id = @proxy_for_id
      end
      @blip
    end

    def params
      ret = {
        'waveletId' => @wavelet_id,
        'waveId' => @wave_id,
        'blipData' => @blip_data
      }
      ret['proxyingFor'] = @proxy_for_id if @proxy_for_id
      ret
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
        'waveletId' => "#{domain}!conv+root",
        'waveId' => @wave_id,
        'waveletTitle' => @title
      }
    end
  end

  class WaveletAddParticipantOperation < Operation
    def initialize(wave_id, wavelet_id, participant_id)
      @method = 'wavelet.participant.add'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @participant_id = participant_id
    end

    def params
      {
        'waveletId' => @wavelet_id,
        'waveId' => @wave_id,
        'participantId' => @participant_id
      }
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
    def initialize(wave_id, wavelet_id, participant_id, role)
      @method = 'wavelet.modifyParticipantRole'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @participant_id = participant_id
      @role = role
    end

    def params
      {
        'waveletId' => @wavelet_id,
        'waveId' => @wave_id,
        'participantId' => @participant_id,
        'role' => @role
      }
    end
  end

  class BlipCreateChildOperation < Operation
    attr_reader :blip_data

    def initialize(wave_id, wavelet_id, parent_blip_id)
      @method = 'blip.createChild'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @blip_data = WaveService.new_blip_data(wave_id, wavelet_id, '', parent_blip_id)
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
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @blip_id = parent_blip_id
      @inline_blip_data = WaveService.new_blip_data(wave_id, wavelet_id, '', parent_blip_id)
      @position = position
    end

    def params
      {
        'waveId' => @wave_id,
        'waveletId' => @wavelet_id,
        'blipId' => @blip_id,
        'index' => @position,
        'blipData' => @inline_blip_data
      }
    end
  end

  class DocumentModifyOperation < Operation
    def initialize(wave_id, wavelet_id, blip_id, modify_action, opts={})
      @method = 'document.modify'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @blip_id = blip_id
      @modify_action = modify_action
      @modify_query = opts[:query]
      @proxy_for_id = opts[:proxy_for_id]
    end

    def params
      ret = {
        'waveId' => @wave_id,
        'waveletId' => @wavelet_id,
        'blipId' => @blip_id,
        'modifyAction' => @modify_action.to_hashmap
      }
      ret['proxyingFor'] = @proxy_for_id if @proxy_for_id
      ret['modifyQuery'] = @modify_query.to_hashmap if @modify_query
      ret
    end
  end

  class RobotCreateWaveletOperation < Operation
    attr_reader :wavelet_data

    def initialize(wave_id, wavelet_id, wavelet_data, message=nil)
      @method = 'robot.createWavelet'
      @wave_id = wave_id
      @wavelet_id = wavelet_id
      @wavelet_data = wavelet_data
      @message = message
    end

    def params
      ret = {
        'waveId' => @wave_id,
        #'waveletId' => @wavelet_id,
        'waveletData' => @wavelet_data
      }
      ret['message'] = @message.to_s if @message
      ret['waveletId'] = @wavelet_id
      ret
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

  class ModifyAction
    DELETE = 'DELETE'
    REPLACE = 'REPLACE'  
    INSERT = 'INSERT'
    INSERT_AFTER = 'INSERT_AFTER'
    ANNOTATE = 'ANNOTATE'
    CLEAR_ANNOTATION = 'CLEAR_ANNOTATION'
    UPDATE_ELEMENT = 'UPDATE_ELEMENT'

    def self.insert_after(elements)
      self.new(INSERT_AFTER, elements)
    end

    def self.update_element(type, properties)
      self.new(UPDATE_ELEMENT, 'type' => type.class_type, 'properties' => properties)
    end

    def initialize(modify_how, elements)
      @modify_how = modify_how
      elements = [elements] unless elements.is_a?(Array)
      if elements.first.is_a?(Element)
        @elements = elements
      else
        @values = elements
      end
    end

    def to_hashmap
      hash = {'modifyHow' => @modify_how}
=begin
      if @elements
        hash['elements'] = @elements.map{|e| e.to_hashmap}
      elsif @values
        hash['values'] = @values.map{|v| v.to_hashmap}
      end
=end
      if @elements
        hash['elements'] = @elements.map{|e| e.to_hashmap}
      elsif @values
        if @modify_how == UPDATE_ELEMENT
          hash['elements'] = @values.map{|e| e.to_hashmap}
        else
          hash['values'] = @values.map{|e| e.to_hashmap}
        end
      end
      hash
    end

    def to_json
      self.to_hashmap.to_json
    end
  end

  class ModifyQuery
    def initialize(blip_ref)
      @blip_ref = blip_ref
    end

    def to_hashmap
      query = nil
      unless @blip_ref.findwhat.nil?
        query = {'maxRes' => @blip_ref.maxres}
        if @blip_ref.findwhat.kind_of?(String)
          query['textMatch'] = findwhat
        else
          query['elementMatch'] = @blip_ref.findwhat.class_type
          query['restrictions'] = @blip_ref.restrictions
        end
      end
      query
    end

    def to_json
      self.to_hashmap.to_json
    end
  end
end
