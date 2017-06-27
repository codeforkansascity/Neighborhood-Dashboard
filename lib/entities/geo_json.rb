require 'json'

module Entities
  class GeoJson
    extend Utilities::AttributesList
    include Utilities::AttributesListInstance

    MAPPABLE_ITEMS = -> item {
      item.mappable?
    }

    attr_accessor :type

    def initialize(args = {})
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def disclosure_attributes
      []
    end

    def properties
      {}
    end

    def geometry
      {}
    end

    def mappable?
      false
    end

    def to_h
      hash = attributes.each_with_object({}) do |attribute, h|
        h[attribute] = self.instance_variable_get("@#{attribute.to_s}")
      end

      hash[:properties] = properties.dup
      hash[:properties][:disclosure_attributes] = disclosure_attributes
      hash[:geometry] = geometry
      hash
    end

    def self.deserialize(hash)
      self.new(JSON.parse(hash.to_json))
    end
  end
end
