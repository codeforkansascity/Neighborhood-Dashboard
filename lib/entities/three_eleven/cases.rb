module Entities::ThreeEleven
  class Cases < ::Entities::MultiDatasetGeoJson
    attr_accessor :metadata

    def properties 
      {
        "color" => '#ffffff'
      }
    end

    def disclosure_attributes
      title = "<h3 class='info-window-header'>Three Eleven Data:</h3>&nbsp;<a href='#{KcmoDatasets::ThreeElevenCases::SOURCE_URI}'>Source</a>"
      last_updated = "Last Updated Date: #{last_updated_date}"
      location_address = "<b>Address:</b>&nbsp;#{address}"
      [title, last_updated, location_address] + super
    end

    def address
      first_dataset = @datasets.first

      if first_dataset
        first_dataset.address.titleize
      else
        'N/A'
      end
    end

    def geometry
      first_dataset = @datasets.first

      if first_dataset
        first_dataset.geometry
      else
        {}
      end
    end

    def mappable?
      @datasets.first.try(&:mappable?)
    end

    def latitude
      first_dataset = @datasets.first
      
      if first_dataset
        first_dataset.latitude
      else
        ""
      end
    end

    def longitude
      first_dataset = @datasets.first
      
      if first_dataset
        first_dataset.longitude
      else
        ""
      end
    end

    private

    def last_updated_date
      DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
    rescue
      'N/A'
    end      
  end
end