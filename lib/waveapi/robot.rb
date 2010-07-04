require 'digest/sha1'
require 'json'
require 'waveapi/message_bundle'
require 'waveapi/operation'
require 'waveapi/handler'
require 'waveapi/context'

module Waveapi
  class Robot
    attr_accessor :verify_token, :operation_bundle

    def initialize(name, opts={})
      @name = name
      @base_url = opts[:base_url] || ''
      @base_url = @base_url[0..-2] if @base_url[-1] == ?/
      @image_url = opts[:image_url] || 'http://example.com/image.png'
      @profile_url = opts[:profile_url] || 'http://example.com/profile.png'
      @event_table = {}
    end

    def handle(json_str)
      puts "---- INPUT\n#{json_str}"
      @context = Context.new(json_str, capabilities_hash)

      wavelet = message_bundle.wavelet
      message_bundle.events.each do |event|
        handlers = @event_table[event.class] || []
        handlers.each do |handler|
          handler.call(event, wavelet)
        end
      end

      puts "---- OUTPUT\n#{@context.operation_bundle.to_json}"
      @context.operation_bundle.to_json
    end

    def register_handler(event_class, opts={}, &block)
      (@event_table[event_class] ||= []) << Handler.new(opts, &block)
      self
    end

    def profile_json
      {:name => @name, :imageUrl => @image_url, :profileUrl => @profile_url}.to_json
    end

    def capabilities_hash
      @capabilities_hash ||=
        Digest::SHA1.hexdigest(
          @event_table.map do |e, hs|
            hs.map{|h| "#{e.type}#{h.context}#{h.filter}"}.join('')
          end.join('')
        )
    end

    def capabilities_xml
      head = <<-EOS
<?xml version="1.0"?>
<w:robot xmlns:w="http://wave.google.com/extensions/robots/1.0">
<w:version>#{capabilities_hash}</w:version>
<w:protocolversion>0.21</w:protocolversion>
<w:capabilities>
      EOS
      body = 
        @event_table.map do |e, hs|
          hs.map{|h| "  <w:capability #{e.type_attr} #{h.opt_attrs}/>"}.join("\n")
        end.join("\n")
      tail = <<-EOS

</w:capabilities>
</w:robot>
      EOS
      head + body + tail
    end

    def start(framework=:sinatra)
      case framework
      when :sinatra
        start_on_sinatra
      else
        raise ArgumentError.new("Not Yet: #{framework}")
      end
    end

    def start_on_sinatra
      require 'sinatra'

      robot = self

      get "#{@base_url}/_wave/verify_token" do
        robot.verify_token
      end if @verify_token

      get "#{@base_url}/_wave/robot/profile" do
        content_type :json
        robot.profile_json
      end

      get "#{@base_url}/_wave/capabilities.xml" do
        content_type :xml
        robot.capabilities_xml
      end

      post "#{@base_url}/_wave/robot/jsonrpc" do
        content_type :json
        robot.handle(request.body.read)
      end
    end
  end
end
