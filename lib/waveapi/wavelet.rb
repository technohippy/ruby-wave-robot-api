require 'waveapi/operation'

module Waveapi
  class Wavelet
    attr_accessor :blips

    def initialize(robot, blips, json)
      @robot = robot
      @blips = blips
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
    end

    def title=(title)
      @robot.add_operation(WaveletSetTitleOperation.new(@wave_id, title))
    end

    def reply(message)
      @robot.add_operation(WaveletAppendBlipOperation.new(@wave_id, message))
    end
  end
end
