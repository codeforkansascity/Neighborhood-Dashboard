module Entities::PropertyViolations
  class Violations < ::Entities::MultiDatasetGeoJson

    attr_accessor :metadata

    def properties 
      {
        "color" => '#ffffff'
      }
    end

    def disclosure_attributes
      title = "<h3 class='info-window-header'>Property Violations:</h3>&nbsp;<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'>Source</a>"
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
      @datasets.first && @datasets.first.mappable?
    end

    def latitude
      if @datasets.first 
        @datasets.first.latitude
      else
        ""
      end
    end

    def longitude
      if @datasets.first 
        @datasets.first.longitude
      else
        ""
      end
    end

    private

    def last_updated_date
      DateTime.strptime(@metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
    rescue
      'N/A'
    end
  end
end
