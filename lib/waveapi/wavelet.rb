require 'waveapi/operation'

module Waveapi
  class Wavelet
    attr_reader :wave_id, :wavelet_id, :creator, :creation_time, :participants, :root_blip, :context
    attr_accessor :blips, :proxy_for_id

    def initialize(json, context)
      @context = context
      @blips = @context.blips
      @raw_json = json
      @wave_id = json['waveId']
      @wavelet_id = json['waveletId']
      @creator = json['creator']
      @creation_time = json['creationTime'] || 0
      @data_documents = {} # TODO
      @last_modified_time = json['lastModifiedTime']
      @participants = Participants.new(json['participants'], json['participantRoles'],
        @wave_id, @wavelet_id, @context)
      @title = json['title'] || ''
      #@tags = 
      @root_blip_id = json['rootBlipId']
      @root_blip = @context.find_blip_by_id(@root_blip_id)
      @proxy_for_id = nil
    end

    def domain
      @wave_id.split('!').first
    end

    def title=(title)
      @context.add_operation(WaveletSetTitleOperation.new(@wave_id, title))
    end

    def reply(message=nil)
      operation = WaveletAppendBlipOperation.new(@wave_id, @context, message, @proxy_for_id)
      @context.add_operation(operation)
      operation.blip
    end

    def proxy_for(proxy_for_id)
      operation = WaveletAddParticipantOperation.new(@wave_id, @wavelet_id, 
        @context.address_for_proxy(proxy_for_id))
      @context.add_operation(operation)
      ret = self.class.new(@raw_json, @context)
      ret.proxy_for_id = proxy_for_id
      ret
    end

    def submit_with(other_wavelet)
      @context.operation_bundle.each do |operation|
        other_wavelet.context.add_operation(operation)
      end
      @context = other_wavelet.context
    end

    def to_hashmap
      {
        "rootBlipId" => @root_blip_id,
        "creator" => @creator,
        "blips" => Hash[*@blips.to_a.map{|k, v| [k, v.to_hashmap]}.flatten],
        "title" => @title,
        "creationTime" => @creation_time,
        "dataDocuments" => @data_document,
        "waveletId" => @wavelet_id,
        "participants" => @participants.participants,
        "waveId" => @wave_id,
        "lastModifiedTime" => @last_modified_time
      }
    end

    def to_json
      to_hashmap.to_json
    end
  end
end
