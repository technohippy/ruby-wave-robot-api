require 'json'
require 'waveapi/event'
require 'waveapi/context'

module Waveapi
  class MessageBundle
    attr_reader :raw_data, :events, :wavelet, :blips, :robot_address

    def initialize(json_str, context)
      @context = context
      @context.message_bundle = self
      @raw_data = json_str
      unless json_str.empty?
        @raw_json = JSON.parse(json_str)
        @robot_address = @raw_json['robotAddress']
        @wavelet = Wavelet.new(@raw_json['wavelet'], @context)
      end
    end

    def blips
      unless @blips
        @blips = {}
        @raw_json['blips'].each{|bid, json| @blips[bid] = Blip.new(json, @context)} if @raw_json
      end
      @blips
    end

    def events
      @events ||= (@raw_json['events'] || []).map{|json| Event.build(json, @context)}
    end
  end
end
