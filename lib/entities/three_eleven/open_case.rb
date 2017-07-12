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

    def latitude
      if address_with_geocode.present?
        address_with_geocode['coordinates'][1]
      else
        ""
      end
    end

    def longitude
      if address_with_geocode.present?
        address_with_geocode['coordinates'][0]
      else
        ""
      end
    end
  end
end
