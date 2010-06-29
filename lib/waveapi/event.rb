module Waveapi
  class Event
    ALL = 'ALL'
    PARENT = 'PARENT'
    CHILDREN = 'CHILDREN'
    SIBLINGS = 'SIBLINGS'
    SELF = 'SELF'
    ROOT = 'ROOT'

    def self.build_from_json(json)
      class_name = json['type'].split('_').map{|e| e.capitalize}.join('') + 'Event'
      eval(class_name).new(json)
    end

    def self.type_attr
      "name=\"#{type}\""
    end
  end

  class WaveletBlipCreatedEvent < Event
    def self.type
      "WAVELET_BLIP_CREATED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class WaveletBlipRemovedEvent < Event
    def self.type
      "WAVELET_BLIP_REMOVED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class WaveletParticipantsChangedEvent < Event
    def self.type
      "WAVELET_PARTICIPANTS_CHANGED"
    end

    attr_reader :participants_added, :participants_removed

    def initialize(json)
      @raw_json = json
      @participants_added = json["participantsAdded"]
      @participants_removed = json["participantsRemoved"]
    end
  end

  class WaveletSelfAddedEvent < Event
    def self.type
      "WAVELET_SELF_ADDED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class WaveletSelfRemovedEvent < Event
    def self.type
      "WAVELET_SELF_REMOVED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class WaveletTagsChangedEvent < Event
    def self.type
      "WAVELET_TAGS_CHANGED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class WaveletTitleChangedEvent < Event
    def self.type
      "WAVELET_TITLE_CHANGED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class BlipContributorChangedEvent < Event
    def self.type
      "BLIP_CONTRIBUTOR_CHANGED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class BlipSubmittedEvent < Event
    def self.type
    "BLIP_SUBMITTED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class DocumentChangedEvent < Event
    def self.type
      "DOCUMENT_CHANGED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class FormButtonClickedEvent < Event
    def self.type
      "FORM_BUTTON_CLICKED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class GadgetStateChangedEvent < Event
    def self.type
      "GADGET_STATE_CHANGED"
    end

    def initialize(json)
      @raw_json = json
    end
  end

  class AnnotatedTextChangedEvent < Event
    def self.type
      "ANNOTATED_TEXT_CHANGED"
    end

    def initialize(json)
      @raw_json = json
    end
  end
end
