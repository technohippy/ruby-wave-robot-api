module Waveapi
  class Event
    CONTEXT_ALL = 'ALL'
    CONTEXT_PARENT = 'PARENT'
    CONTEXT_CHILDREN = 'CHILDREN'
    CONTEXT_SIBLINGS = 'SIBLINGS'
    CONTEXT_SELF = 'SELF'
    CONTEXT_ROOT = 'ROOT'

    def self.build(json, context)
      class_name = json['type'].split('_').map{|e| e.capitalize}.join('') + 'Event'
      eval(class_name).new(json, context)
    end

    def self.type_attr
      "name=\"#{type}\""
    end

    attr_reader :raw_json, :modified_by, :timestamp, :type, :properties, :blip_id, :blip, :proxying_for

    def initialize(json, context=nil)
      @raw_json = json
      @modified_by = json['modifiedBy']
      @timestamp = json['timestamp'] || 0
      @type = json['type']
      @properties = json['properties']
      @blip_id = @properties['blipId']
      @blip = context.find_blip_by_id(@blip_id)
      @proxying_for = json['proxyingFor']
    end
  end

  class WaveletBlipCreatedEvent < Event
    def self.type
      "WAVELET_BLIP_CREATED"
    end

    attr_reader :new_blip_id, :new_blip

    def initialize(json, blips=[])
      super
      @new_blip_id = @properties['newBlipId']
      @new_blip = @context.find_blip_by_id(@new_blip_id)
    end
  end

  class WaveletBlipRemovedEvent < Event
    def self.type
      "WAVELET_BLIP_REMOVED"
    end

    attr_reader :removed_blip_id, :removed_blip

    def initialize(json, blips=[])
      super
      @removed_blip_id = @properties['removedBlipId']
      @removed_blip = @context.find_blip_by_id(@removed_blip_id)
    end
  end

  class WaveletParticipantsChangedEvent < Event
    def self.type
      "WAVELET_PARTICIPANTS_CHANGED"
    end

    attr_reader :participants_added, :participants_removed

    def initialize(json, blips=[])
      super
      @participants_added = @properties['participantsAdded'] || []
      @participants_removed = @properties['participantsRemoved'] || []
    end
  end

  class WaveletSelfAddedEvent < Event
    def self.type
      "WAVELET_SELF_ADDED"
    end

    def initialize(json, blips=[])
      super
    end
  end

  class WaveletSelfRemovedEvent < Event
    def self.type
      "WAVELET_SELF_REMOVED"
    end

    def initialize(json, blips=[])
      super
    end
  end

  class WaveletTagsChangedEvent < Event
    def self.type
      "WAVELET_TAGS_CHANGED"
    end

    def initialize(json, blips=[])
      super
    end
  end

  class WaveletTitleChangedEvent < Event
    def self.type
      "WAVELET_TITLE_CHANGED"
    end

    attr_reader :title

    def initialize(json, blips=[])
      super
      @title = @properties['title']
    end
  end

  class BlipContributorsChangedEvent < Event
    def self.type
      "BLIP_CONTRIBUTORS_CHANGED"
    end

    attr_reader :contributors_added, :contributors_removed

    def initialize(json, blips=[])
      super
      @contributors_added = @properties['contributorsAdded'] || []
      @contributors_removed = @properties['contributorsremoved'] || []
    end
  end

  class BlipSubmittedEvent < Event
    def self.type
    "BLIP_SUBMITTED"
    end

    def initialize(json, blips=[])
      super
    end
  end

  class DocumentChangedEvent < Event
    def self.type
      "DOCUMENT_CHANGED"
    end

    def initialize(json, blips=[])
      super
    end
  end

  class FormButtonClickedEvent < Event
    def self.type
      "FORM_BUTTON_CLICKED"
    end

    attr_reader :button_name

    def initialize(json, blips=[])
      super
      @button_name = @properties['buttonName']
    end
  end

  class GadgetStateChangedEvent < Event
    def self.type
      "GADGET_STATE_CHANGED"
    end

    attr_reader :index, :old_state

    def initialize(json, blips=[])
      super
      @index = @properties['index']
      @old_state = @properties['oldState']
    end
  end

  class AnnotatedTextChangedEvent < Event
    def self.type
      "ANNOTATED_TEXT_CHANGED"
    end

    attr_reader :name, :value

    def initialize(json, blips=[])
      super
      @name = @properties['name']
      @value = @properties['value']
    end
  end

  class OperationErrorEvent < Event
    def self.type
      "OPERATION_ERROR"
    end

    attr_reader :operation_id, :error_message

    def initialize(json, blips=[])
      super
      @operation_id = @properties['operationId']
      @error_message = @properties['message']
    end
  end

  class WaveletCreatedEvent < Event
    def self.type
      'WAVELET_CREATED'
    end

    attr_reader :message

    def initialize(json, blips=[])
      super
      @message = @properties['message']
    end
  end

  class WaveletFetchedEvent < Event
    def self.type
      "WAVELET_FETCHED"
    end

    attr_reader :message

    def initialize(json, blips=[])
      super
      @message = @properties['message']
    end
  end

  class WaveletTagsChangedEvent < Event
    def self.type
      "WAVELET_TAGS_CHANGED"
    end

    def initialize(json, blips=[])
      super
    end
  end
end
