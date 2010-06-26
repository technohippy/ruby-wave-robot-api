require 'json'

module Waveapi
  class MessageBundle
    attr_reader :raw_data, :events, :wavelet, :blips, :robot_address

    def init(json_str)
      @raw_data = json_str
      @raw_json = JSON.parse(json_str).dup

      @events = @raw_json[:events].map{|e| Event.build_from_json(e)}
      @wavelet = Wavelet.new(@raw_json[:wavelet])
      @blips = @raw_json[:blips].map{|e| Blip.new(e)}
      @robot_address = @raw_json[:robotAddress]
    end
  end
end
