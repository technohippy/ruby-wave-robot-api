module Waveapi
  class BlipRefs
    DELETE = 'DELETE'
    REPLACE = 'REPLACE'  
    INSERT = 'INSERT'
    INSERT_AFTER = 'INSERT_AFTER'
    ANNOTATE = 'ANNOTATE'
    CLEAR_ANNOTATION = 'CLEAR_ANNOTATION'
    UPDATE_ELEMENT = 'UPDATE_ELEMENT'

    attr_accessor :findwhat, :restrictions, :params, :hits, :range, :blip, :maxres

    def initialize(blip, maxres=1)
      @blip = blip
      @maxres = maxres
      @context = blip.context
    end

    def self.all(blip, findwhat, maxres=-1, restrictions={})
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

    def find(what, maxres=-1, restrictions={})
      if what.nil?
        #[[0, blip.size]].to_enum
        [[0, blip.size]]
      elsif what.is_a?(String)
        find_strings(what, maxres)
      else
        find_elements(what, maxres, restrictions)
      end
    end

    def find_strings(string, maxres=-1)
      ranges = []
      start = 0
      while idx = @blip.content.index(what, start)
        ranges << [idx, idx + what.size]
        start += what.size
        break if maxres <= ranges.size
      end
      #ranges.to_enum
      ranges
    end

    def find_elements(what, maxres=-1, restrictions={})
      ranges = []
      @blip.elements.to_a.sort{|a1, a2| a1[0] <=> a2[0]}.each do |idx, el|
        if elem_matches(el, what, restrictions)
          ranges << [idx, idx + 1]
          break if maxres <= ranges.size
        end
      end
      #ranges.to_enum
      ranges
    end

    def elem_matches(el, klass, restrictions)
      return false unless el.is_a?(klass)
      restrictions.each do |key, val|
        return false unless el.send(key) == val
      end
      return true
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
        :proxy_for_id => @blip.proxy_for_id)
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

    def check_hit_range(first, last)
      if first < 0
        first += blip.size
        last += blip.size if last == 0
      end
      last += blip.size if last < 0 
      if blip.size == 0
        unless first == 0 and last == 0
          raise ArgumentError.new('Start and end have to be 0 for empty document')
        end
      elsif first < 0 or last < 1 or blip.size <= first or blip.size < last
        raise ArgumentError.new('Position outside the document')
      end
      [first, last]
    end

    def update_element(new_values)
=begin
      #execute(UPDATE_ELEMENT, new_values)
      new_values = [new_values] unless new_values.is_a?(Array)
      next_index = 0
      matched = []
      updated_elements = []
      nxt = nil

      hit_found = false
      self.hits.call.each do |first, last|
        hit_found = true
        first, last = check_hit_range(first, last)
        if new_values.is_a?(Proc)
          nxt = new_values.call(blip.content, first, last)
          matched << nxt
        else
          nxt = new_values[next_index]
          next_index = (next_index + 1) % new_values.size
        end

        el = blip.elements[first]
        raise ArgumentError.new("No element found at index #{first}")
        updated_elements << Element.from_json('type' => el.type, 'properties' => nxt)
        nxt.each{|k, v| el[k] = v}
      end
      return unless hit_found
=end

      operation = DocumentModifyOperation.new(@blip.wave_id, 
        @blip.wavelet_id, @blip.blip_id, 
        ModifyAction.update_element(@findwhat, new_values),
        :query => ModifyQuery.new(self),
        :proxy_for_id => @blip.proxy_for_id
      )
      @context.add_operation(operation)
      
    end

    def get(attribute, default=nil)
      self.value.get(attribute, default)
    end

    def value
      first, last = *hits.call.first
      if last
        if last - first == 1 and blip.elements.include?(first)
          blip.elements[first]
        else
          blip.text[first..last]
        end
      else
        raise ArgumentError.new("BlipRefs has no values: #{self}")
      end
    end

    def each(&block)
      hits.call.each do |start_end|
        block.call(start_end)
      end
    end
  end
end
