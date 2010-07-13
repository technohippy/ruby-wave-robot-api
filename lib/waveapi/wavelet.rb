require 'waveapi/operation'

module Waveapi
  class Wavelet
    attr_accessor :blips, :proxy_for_id

    def initialize(json, context)
      @context = context
      @blips = @context.blips
      @raw_json = json
      @wave_id = json['waveId']
      @wavelet_id = json['waveletId']
      @creator = json['creator']
      @creation_time = json['creationTime'] || 0
      #@data_documents = 
      @last_modified_time = json['lastModifiedTime']
      #@participants = 
      @title = json['title'] || ''
      #@tags = 
      @root_blip_id = json['rootBlipId']
      #@root_blip = 
      @proxy_for_id = nil
    end

    def title=(title)
      @context.add_operation(WaveletSetTitleOperation.new(@wave_id, title))
    end

    def reply(message=nil)
      operation = WaveletAppendBlipOperation.new(@wave_id, @context, message)
      @context.add_operation(operation)
      operation.blip
    end

    def proxy_for(proxy_for_id)
      ret = self.class.new(@raw_json, @context)
      ret.proxy_for_id = proxy_for_id
      ret
    end
  end
end
