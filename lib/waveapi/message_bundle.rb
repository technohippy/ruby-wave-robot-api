require 'json'

module Waveapi
  class MessageBundle
    attr_reader :raw_data, :events, :wavelet, :blips, :robot_address

    def initialize(json_str, robot)
      @raw_data = json_str
      @raw_json = JSON.parse(json_str).dup

      @events = (@raw_json['events'] || []).map{|json| Event.build_from_json(json)}
      @blips = (@raw_json['blips'] || []).map{|json| Blip.new(robot, json)}
      @wavelet = Wavelet.new(robot, @blips, @raw_json['wavelet'])
      @robot_address = @raw_json['robotAddress']
    end
  end
end
