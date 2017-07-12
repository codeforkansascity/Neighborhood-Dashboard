module Entities::Vacancy
  class DangerousBuilding < ::Entities::GeoJson
    attr_accessor :location, :statusofcase, :metadata

    def initialize(args)
      super(args)
    end

    def properties
      {
        color: '#ffffff'
      }
    end

    def disclosure_attributes
      source_link = "<a href='#{KcmoDatasets::DangerousBuildings::SOURCE_URI}'><small>(Source)</small></a>"

      [
        "<h2 class='info-window-header'>Dangerous Building</h2>&nbsp;#{source_link}",
        "Last Updated: #{last_updated_date}",
        statusofcase
      ]
    end

    def geometry
      location
    end

    def mappable?
      geometry.present?
    end

    def latitude
      if geometry
        geometry['coordinates'][1]
      else
        ""
      end
    end

    def longitude
      if geometry
        geometry['coordinates'][0]
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
