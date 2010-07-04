module Waveapi
  class Entity
    def attrs_from_json(json, props)
      props.each do |name, default|
        eval %Q{
          @#{underline(name)} = json['#{name}'] || #{default.inspect}
        }
      end
    end

    def underline(camelcase)
      camelcase.gsub(/[A-Z]/){|c| '_' + c.downcase}
    end
  end
end
