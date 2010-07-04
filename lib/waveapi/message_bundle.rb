require 'json'
require 'waveapi/context'

module Waveapi
  class MessageBundle
    attr_reader :raw_data, :events, :wavelet, :blips, :robot_address

    def initialize(json_str, operation_bundle)
      @context = Context.new(self, operation_bundle)
      @raw_data = json_str
      puts @raw_data
      @raw_json = JSON.parse(json_str).dup
      @robot_address = @raw_json['robotAddress']
      @wavelet = Wavelet.new(@raw_json['wavelet'], @context)
    end

    def blips
      @blips ||= (@raw_json['blips'] || {}).map{|bid, json| Blip.new(json, @context)}
    end

    def events
      @events ||= (@raw_json['events'] || []).map{|json| Blip.new(json, @context)}
    end
  end
end
