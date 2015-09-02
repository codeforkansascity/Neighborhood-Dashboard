class Neighborhood::CrimeData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def yearly_counts
    # TODO: Append the within_polygon to the where clause for the data set.
    service_url = URI::escape("https://data.kcmo.org/resource/nsn9-g8a4.json?#{query_polygon}")
    crimes = HTTParty.get(service_url, verify: false)

    yearly_counts = {}

    crimes.each do |crime|
      if crime['from_date'].present?
        year = Date.parse(crime['from_date']).try(:year)
        yearly_counts[year] = yearly_counts[year].to_i + 1
      end
    end

    Hash[yearly_counts]
  end

  def map_coordinates
    service_url = URI::escape("https://data.kcmo.org/resource/nsn9-g8a4.json?#{query_polygon}")
    coordinates = HTTParty.get(service_url, verify: false)

    # Not every coordinate is guaraneed to have location_1 populated with coordinates
    coordinates
      .select{ |coordinate|
        coordinate["location_1"].present? && coordinate["location_1"]["coordinates"].present?
      }
      .map { |coordinate|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => coordinate["location_1"]["coordinates"]
          }
        }
      }
  end

  private

  def query_polygon
    coordinates = @neighborhood.coordinates.map{ |neighborhood|
      "#{neighborhood.latitude} #{neighborhood.longtitude}"
    }.join(',')

    "$where=within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')"
  end
end
