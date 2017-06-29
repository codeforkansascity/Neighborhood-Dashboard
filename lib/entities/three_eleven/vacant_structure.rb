module Entities::ThreeEleven
  class VacantStructure < ::Entities::GeoJson
    attr_accessor :street_address, :address_with_geocode, :request_type

    def disclosure_attributes
      [
        request_type
      ]
    end

    def address
      street_address
    end

    def geometry
      {
        "type" => "Point",
        "coordinates" => address_with_geocode["coordinates"]
      }
    end

    def mappable?
      address_with_geocode["coordinates"].present?
    end
  end
end
