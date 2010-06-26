module Waveapi
  class Event
    def self.build_from_json(json)
      class_name = json['type'].split('_').map{|e| e.capitalize}.join('') + 'Event'
      eval(class_name).new(json)
    end
  end

  class BlipSubmittedEvent < Event
    def initialize(json)
      @raw_json = json
    end
  end
end
