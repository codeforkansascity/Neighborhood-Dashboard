class Neighborhood::CrimeData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def yearly_counts
    # TODO: Append the within_polygon to the where clause for the data set.
    service_url = URI::escape("https://data.kcmo.org/resource/dfzx-ty3t.json")
    crimes = HTTParty.get(service_url)

    yearly_counts = {}

    crimes.each do |crime|
      if crime['from_date'].present?
        year = Date.parse(crime['from_date']).try(:year)
        yearly_counts[year] = yearly_counts[year].to_i + 1
      end
    end

    Hash[yearly_counts]
  end

  private

  def query_polygon
    coordinates = @neighborhood.coordinates.map{ |neighborhood| 
      "#{neighborhood.latitude} #{neighborhood.longtitude}"
    }.join(',')

    "$where=within_polygon(location, 'MULTIPOLYGON (((#{coordinates})))')"
  end
end
