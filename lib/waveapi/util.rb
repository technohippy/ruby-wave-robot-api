module Waveapi
  module Util
    def parse_markup(markup)
      markup.gsub(/<([^>]*?)>/) do |match|
        tag = $1.split(' ', 2).first
        ['p', 'br'].include?(tag) ? "\n" : ''
      end
    end
  end
end
