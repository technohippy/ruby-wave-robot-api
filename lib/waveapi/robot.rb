require 'waveapi/message_bundle'

module Waveapi
  class Robot
    def initialize(name, opts)
      @name = name
      @image_url = opts[:image_url] || 'http://example.com/image.png'
      @profile_url = opts[:profile_url] || 'http://example.com/profile.png'
    end

    def handle(json_str)
      message_bundle = MessageBundle.new(json_str)      
    end
  end
end
