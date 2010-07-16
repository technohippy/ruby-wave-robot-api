module Waveapi
  class Annotation
    attr_reader :name, :value, :start, :finish

    BACKGROUND_COLOR = "style/backgroundColor"
    COLOR = "style/color"
    FONT_FAMILY = "style/fontFamily"
    FONT_SIZE = "style/fontSize"
    FONT_STYLE = "style/fontStyle"
    FONT_WEIGHT = "style/fontWeight"
    TEXT_DECORATION = "style/textDecoration"
    VERTICAL_ALIGN = "style/verticalAlign"

    def initialize(name, value, start, finish)
      @name, @value, @start, @finish = name, value, start, finish
    end

    def shift(where, inc)
      @start += inc if where <= @start
      @finish += inc if where <= @finish
    end

    def to_hashmap
      {
        'name' => @name,
        'value' => @value,
        'range' => {
          'start' => @start,
          'end' => @finish
        }
      }
    end
  end
end
