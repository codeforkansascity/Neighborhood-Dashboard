module Entities::PropertyViolations
  class Violation < ::Entities::GeoJson
    attr_accessor :status, :violation_description, :address, :mapping_location

    def disclosure_attributes
      [
        violation_description
      ]
    end

    def geometry
      {
        'type' => 'Point',
        'coordinates' => mapping_location['coordinates']
      }
    end

    def mappable?
      mapping_location.present? && mapping_location['longitude'].present?
    end

    def latitude
      if mapping_location.present?
        mapping_location['coordinates'][1]
      else
        ""
      end
    end

    def longitude
      if mapping_location.present?
        mapping_location['coordinates'][0]
      else
        ""
      end
    end
  end
end
