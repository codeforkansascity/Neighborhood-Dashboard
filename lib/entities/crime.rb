module Entities
  class Crime < GeoJson
    attr_accessor :ibrs, :description, :address, :from_date, :dataset_year, :source, :last_updated, :location_1

    def initialize(args)
      super(args)
    end

    def properties
      {
        color: crime_marker_color
      }
    end

    def disclosure_attributes
      [
        description,
        address.try(:titleize),
        crime_data_text,
        "<a href=#{source}>Data Source</a>",
        "Last Updated: #{last_updated_date}"
      ]
    end

    def geometry
      location_1
    end

    def mappable?
      geometry['coordinates'].present?
    end

    private

    def crime_data_text
      "Committed on #{DateTime.parse(from_date).strftime('%m/%d/%Y')}"
    rescue
      "Committed in #{dataset_year}"
    end

    def last_updated_date
      DateTime.strptime(last_updated.to_s, '%s').strftime('%m/%d/%Y')
    rescue
      'N/A'
    end

    def crime_marker_color
      case
      when CrimeMapper::CRIME_CATEGORIES[:PERSON].include?(ibrs)
        '#626AB2'
      when CrimeMapper::CRIME_CATEGORIES[:PROPERTY].include?(ibrs)
        '#313945'
      when CrimeMapper::CRIME_CATEGORIES[:SOCIETY].include?(ibrs)
        '#6B7D96'
      else
        '#ffffff'
      end
    end
  end
end
