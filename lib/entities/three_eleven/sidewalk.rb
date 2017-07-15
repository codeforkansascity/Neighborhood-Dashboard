module Entities::ThreeEleven
  class Sidewalk < ::Entities::GeoJson
    attr_accessor :street_address, :creation_date, :case_id, :request_type, :zip_code, :address_with_geocode, :metadata

    def disclosure_attributes
      title = "<h3 class='info-window-header'>Sidewalk Issue:</h3>&nbsp;<a href='#{KcmoDatasets::ThreeElevenCases::SOURCE_URI}'>Source</a>"
      last_updated = "Last Updated Date: #{last_updated_date}"
      location_address = "<b>Address:</b>&nbsp;#{address.try(&:titleize) || 'N/A'}"
      [
        title,
        location_address,
        "<b>Created: </b>#{parsed_creation_date}",
        "<b>Case ID: </b>#{case_id}",
        request_type,
        last_updated
      ] + super
    end

    def geometry
      {
        "type" => "Point",
        "coordinates" => address_with_geocode["coordinates"]
      }
    end

    def properties
      {
        color: '#f2f2f2'
      }
    end

    def address
      street_address
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

    private

    def parsed_creation_date
      DateTime.parse(creation_date).strftime('%m/%d/%Y')
    rescue
      'N/A'
    end

    def last_updated_date
      DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
    rescue
      'N/A'
    end      
  end
end