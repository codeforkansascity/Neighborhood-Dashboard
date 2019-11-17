module Entities::LandBankData
  class LandBanks < ::Entities::MultiDatasetGeoJson

    attr_accessor :metadata, :location_1, :location_1_address, :parcel_number, :longitude, :latitude

    def properties 
      {
        'parcel_number' => parcel_number,
        'color' => land_bank_color
      }
    end

    def disclosure_attributes
      title = "<h3 class='info-window-header'>Land Bank Data:</h3>&nbsp;<a href='#{KcmoDatasets::LandBankData::SOURCE_URI}' target='_blank'>Source</a>"
      last_updated = "Last Updated Date: #{last_updated_date}"
      location_address = "<b>Address:</b>&nbsp;#{address.try(&:titleize)}"
      [title, last_updated, location_address] + super
    end

    def address
      location_1_address
    end

    def geometry
      {
        "type" => "Polygon",
        "coordinates" => geometric_parcel_coordinates
      }
    end

    def mappable?
      geometry["coordinates"].present?
    end

    private

    def last_updated_date
      DateTime.strptime(@metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
    rescue
      'N/A'
    end

    def land_bank_color
      case Date.today.mjd - Date.parse(@acquisition_date).mjd
      when 0...364
        '#A3F5FF'
      when 365...1094
        '#3A46B2'
      else
        '#000000'
      end
    rescue
      '#ffffff'
    end

    def geometric_parcel_coordinates
      desired_parcel = StaticData::PARCEL_DATA().find { |current_parcel| 
        current_parcel['properties']['apn'] == parcel_number
      }

      if desired_parcel.present? 
        desired_parcel["geometry"]["coordinates"][0]
      else
        []
      end
    end
  end
end
