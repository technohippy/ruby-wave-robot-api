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
end
