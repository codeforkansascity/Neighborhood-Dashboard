module Entities::ThreeEleven
  class OpenCase < ::Entities::GeoJson
    attr_accessor :street_address, :address_with_geocode

    def disclosure_attributes
      [
        'Open Case'
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
