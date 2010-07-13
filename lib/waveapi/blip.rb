require 'waveapi/element'
require 'waveapi/util'

module Waveapi
  class BlipRefs
    DELETE = 'DELETE'
    REPLACE = 'REPLACE'  
    INSERT = 'INSERT'
    INSERT_AFTER = 'INSERT_AFTER'
    ANNOTATE = 'ANNOTATE'
    CLEAR_ANNOTATION = 'CLEAR_ANNOTATION'
    UPDATE_ELEMENT = 'UPDATE_ELEMENT'

    attr_accessor :findwhat, :restrictions, :params, :hits, :range

    def initialize(blip, maxres=1)
      @blip = blip
      @maxres = maxres
      @context = blip.context
    end

    def self.all(blip, findwhat, maxres=nil, restrictions={})
      obj = self.new(blip, maxres)
      obj.findwhat = findwhat
      obj.restrictions = restrictions
      obj.hits = lambda {obj.find(findwhat, maxres, restrictions)}
      if findwhat.nil?
        obj.params = {}
      else
        query = {'maxRes' => maxres}
        if findwhat.kind_of?(String)
          query['textMatch'] = findwhat
        else
          query['elementMatch'] = findwhat.class_type
          query['restrictions'] = restrictions
        end
        obj.params = {'modifyQuery' => query}
      end
      obj
    end

    def self.range(blip, range)
      obj = self.new(blip)
      obj.range = range
      obj.hits = lambda {[range]}
      obj.params = {'ramge' => {'start' => range.begin, 'end' => range.end}}
      obj
    end

    def element_matches(elem, klass, restrictions={})
      return false unless elem.kind_of?(klass)

      restrictions.each do |key, val|
        return falseunless elem.send(key) == val
      end
      true
    end

    def find(what, maxres=nil, restrictions={})
      # TODO
    end

    def execute(modify_how, what, bundled_annotations=nil)
      # TODO
    end

    def insert(what, bundled_annotations=nil)
      execute(INSERT, what, bundled_annotations)
    end

    def insert_after(what, bundled_annotations=nil)
      #execute(INSERT_AFTER, what, bundled_annotations)
      operation = DocumentModifyOperation.new(@blip.wave_id, 
        @blip.wavelet_id, @blip.blip_id, 
        ModifyAction.insert_after(what),
        @blip.proxy_for_id)
      @context.add_operation(operation)
    end

    def replace(what, bundled_annotations=nil)
      execute(REPLACE, what, bundled_annotations)
    end

    def delete
      execute(DELETEE, nil)
    end

    def annotate(name, value=nil)
      execute(ANNOTATE, value.nil? ? name : [name, value])
    end

    def clear_annotation(name)
      execute(CLEAR_ANNOTATION, name)
    end

    def update_element(new_values)
      execute(UPDATE_ELEMENT, new_values)
    end

    def value
      first, last = *hits
      if last
        if last - first == 1 and blip.elements.include?(first)
          blip.elements[first]
        else
          blip.text[first..last]
        end
      else
        raise ArgumentError.new('BlipRefs has no values')
      end
    end

    def each(&block)
      hits.each do |start_end|
        block.call(start_end)
      end
    end
  end

  class Blip
    attr_reader :blip_id, :wave_id, :wavelet_id, :child_blip_ids, :contributors, :creator, :last_modified_time, :version, :parent_blip_id, :annotations, :context
    attr_accessor :proxy_for_id

    def initialize(json, context)
      @context = context
      @raw_json = json
      @blip_id = json['blipId']
      @child_blip_ids = json['childBlipIds'] || []
      @content = json['content'] || ''
      @contributors = json['contributors'] || []
      @creator = json['creator']
      @last_modified_time = json['lastModifiedTime'] || 0
      @version = json['version'] || 0
      @parent_blip_id = json['parentBlipId']
      @wave_id = json['waveId']
      @wavelet_id = json['waveletId']
      @other_blips = @context.blips # ??
      #@annotations = 
      @elements = []
      (@raw_json['elements'] || {}).each do |k, v|
        @elements[k.to_i] = Element.from_json(v)
      end
    end

    def child_blips
      @child_blip_ids.map{|bid| @context.find_blip_by_id(bid)}.compact
    end

    def parent_blip
      @context.find_blip_by_id(@parent_blip_id)
    end

    def inline_blip_offset
      raise ArgumentError.new('Not Yet')
    end

    def elements
      @elements.values
    end

    def size
      @content.size
    end

    def [](index_or_range)
      if index_or_range.kind_of?(Range)
        range(index_or_range)
      else
        at(index_or_range)
      end
    end

    def []=(index_or_range, value)
      self[index_or_range].replace(value)
    end

    def shift(where, inc)
      new_elements = []
      @elements.each_with_index do |val, index|
        index += inc if where <= index
        new_elements[index] = val
      end
      @elements = new_elements
      @anotations.shift(where, inc)
    end

    def delete_annotations(range)
      @annotations.names.each do |name|
        @annotations.delete_internal(name, range)
      end
    end

    def all(findwhat=nil, maxres=nil, restrictions={})
      BlipRefs.all(findwhat, maxres, restrictions)
    end

    def first(findwhat=nil, restrictions={})
      BlipRefs.all(findwhat, 1, restrictions)
    end

    def at(index)
      BlipRefs.range(index..index + 1)
    end

    def range(range_or_start, stop=nil)
      BlipRefs.range(stop.nil? ? range_or_start : (range_or_start..stop))
    end

    def to_hashmap
      {
        'blipId' => @blip_id,
        'childBlipIds' => @child_blip_ids,
        'content' => @content, 
        'creator' => @creator,
        'contributors' => @contributors,
        'lastModifiedTime' => @last_modified_time,
        'version' => @version,
        'parentBlipId' => @parent_blip_id,
        'waveId' => @wave_id,
        'waveletId' => @wavelet_id,
        'annotations' => @annotations.to_hashmap,
        'elements' => @elements.inject([]){|ary, e| ary << [ary.size, e.to_hashmap]}
      }
    end

=begin
    def proxy_for(proxy_for_id)
      context = @context.proxy_for(proxy_for_id)
      res = self.new({}, nil)
      res.blip_id = @blip_id
      res.child_blip_ids = @child_blip_ids
      res.content = @content
      res.contributors = @contributors
      res.creator = @creator
      res.last_modified_time = @last_modified_time
      res.version = @version
      res.parent_blip_id = @parent_blip_id
      res.wave_id = @wave_id
      res.wavelet_id = @wavelet_id
      res.other_blips = @other_blips
      res.annotations = @annotations
      res.elements = @elements
      res.raw_json = @raw_json
      res
    end
=end

    def text
      @content
    end

    def find(what, restrictions={})
      br = BlipRefs.all(what, restrictions)
      # TODO
    end

    def append(what, bundled_annotations=[])
      BlipRefs.all(self, nil).insert_after(what, bundled_annotations)
    end

    def reply
      operation = BlipCreateChildOperation.new(@wave_id, @wavelet_id, @blip_id)
      @context.add_operation(operation)
      new_blip = Blip.new(operation.blip_data, @context)
      @context.add_blip(new_blip)
      new_blip
    end

    def append_markup(markup)
      operation = DocumentAppendMarkupOperation.new(@wave_id, @wavelet_id, @blip_id, markup)
      @context.add_operation(operation)
      @content += Util.parse_markup(markup)
    end

    def insert_inline_blip(position)
      raise ArgumentError.new("Illegal inline blip position: #{position}. " +
        "Position has to be greater than 0.") if position <= 0
      operation = DocumentInlineBlipInsertOperation.new(@wave_id, @wavelet_id, @blip_id, position)
      new_blip = Blip.new(operation.inline_blip_data, @context)
      @context.add_blip(new_blip)
      new_blip
    end
  end
end
