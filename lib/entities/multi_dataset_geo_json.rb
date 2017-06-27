require 'json'

module Entities
  class MultiDatasetGeoJson < GeoJson
    extend Utilities::AttributesList
    include Utilities::AttributesListInstance

    attr_accessor :datasets

    def initialize(args = {})
      super(args)
      @datasets = []
    end

    def add_dataset(dataset)
      @datasets.push(dataset)
    end

    def disclosure_attributes
      @datasets.map(&:disclosure_attributes).flatten.uniq
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
      hash = {}

      hash[:type] = 'Feature'
      hash[:geometry] = geometry
      hash[:properties] = properties.dup
      hash[:properties][:disclosure_attributes] = disclosure_attributes
      hash
    end

    def self.deserialize(hash)
      self.new(JSON.parse(hash.to_json))
    end
  end
end
