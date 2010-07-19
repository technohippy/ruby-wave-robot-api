require 'json'

class Object
  def self.subclasses(direct = false)
    classes = []
    if direct
      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self
        classes << c
      end
    else
      ObjectSpace.each_object(Class) do |c|
        next unless c.ancestors.include?(self) and (c != self)
        classes << c
      end
    end
    classes
  end
end

module Waveapi
  class Element
    attr_reader :type

    def initialize(type, properties={})
      @type = type
      @properties = properties.dup
      @operation_bundle = nil
    end

    def self.from_json(json)
      type = json['type']
      props = json['properties']
      element_classes = Element.subclasses
      element_class = element_classes.find{|cls| cls.class_type == type}
      if element_class
        element_class.from_props(props)
      else
        Element.new(type, props)
      end
    end

    def to_hashmap
      {
        'type' => @type,
        'properties' => @properties.reject{|k, v| v.nil?}
      }
    end

    def to_json
      self.to_hashmap.to_json
    end

    def method_missing(name, *args, &block)
      if args.empty? and block.nil?
        @properties[name.to_s]
      else
        super
      end
    end
  end

  class Input < Element
    def self.class_type; 'INPUT' end
    
    def initialize(name, value='')
      super(self.class.class_type, 
        'name' => name, 
        'value' => value, 
        'default_value' => value)
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class Check < Element
    def self.class_type; 'CHECK' end
    
    def initialize(name, value='')
      super(self.class.class_type, 
        'name' => name, 
        'value' => value, 
        'default_value' => value)
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class Button < Element
    def self.class_type; 'BUTTON' end
    
    def initialize(name, value)
      super(self.class.class_type, 
        'name' => name, 
        'value' => value) 
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class Label < Element
    def self.class_type; 'LABEL' end
    
    def initialize(label_for, caption)
      super(self.class.class_type, 
        'name' => label_for, 
        'value' => caption)
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class RadioButton < Element
    def self.class_type; 'RADIO_BUTTON' end
    
    def initialize(name, group)
      super(self.class.class_type, 
        'name' => name,
        'value' => group)
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class RadioButtonGroup < Element
    def self.class_type; 'RADIO_BUTTON_GROUP' end
    
    def initialize(name, group)
      super(self.class.class_type, 
        'name' => name,
        'value' => group)
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class Password < Element
    def self.class_type; 'PASSWORD' end
    
    def initialize(name, value)
      super(self.class.class_type, 
        'name' => name, 
        'value' => value) 
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class TextArea < Element
    def self.class_type; 'TEXTAREA' end
    
    def initialize(name, value)
      super(self.class.class_type, 
        'name' => name, 
        'value' => value) 
    end

    def self.from_props(props)
      self.new(props['name'], props['value'])
    end
  end

  class Line < Element
    def self.class_type; 'LINE' end
    
    TYPE_H1 = 'h1'
    TYPE_H2 = 'h2'
    TYPE_H3 = 'h3'
    TYPE_H4 = 'h4'
    TYPE_H5 = 'h5'
    TYPE_LI = 'li'

    ALIGN_LEFT = 'l'
    ALIGN_RIGHT = 'r'
    ALIGN_CENTER = 'c'
    ALIGN_JUSTIFIED = 'j'
    
    def initialize(line_type=nil, indent=nil, alignment=nil, direction=nil)
      super(self.class.class_type, 
        'lineType' => line_type, 
        'indent' => indent,
        'alignment' => alignment,
        'direction' => direction)
    end

    def self.from_props(props)
      self.new(props['lineType'], props['indent'], props['alignment'], props['direction'])
    end
  end

  class Gadget < Element
    def self.class_type; 'GADGET' end
    
    def initialize(url, props={})
      @private_properties = {}
      props['url'] = url
      super(self.class.class_type, props)
    end

    def keys
      @properties.keys - ['url']
    end

    def method_missing(name, *args, &block)
      name = name.to_s
      if name[-1] == ?=
        @private_properties[name[0..-2]] = args.first
      else
        @private_properties[name]
      end
    end
  end

  class Installer < Element
    def self.class_type; 'INSTALLER' end
    
    def initialize(manifest)
      super(self.class.class_type, 'manifest' => manifest)
    end

    def self.from_props(props)
      self.new(props['manifest'])
    end
  end

  class Image < Element
    def self.class_type; 'IMAGE' end

    def initialize(url='', width=nil, height=nil, attachmentId=nil, caption=nil)
      super(self.class.class_type, 'url' => url, 'width' => width, 
        'height' => height, 'attachmentId' => attachmentId, 'caption' => caption)
    end

    def self.from_props(props)
      self.new(props['url'], props['width'], props['height'], props['attachmentId'], props['caption'])
    end
  end

  class Attachment < Element
    def self.class_type; 'ATTACHMENT' end
  end
end
