require 'crime_mapper'

class Neighborhood::CrimeData
  RESOURCE_URL = "https://data.kcmo.org/resource/nsn9-g8a4.json"
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def yearly_counts
    service_url = URI::escape("#{RESOURCE_URL}?$where=#{query_polygon}")
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

  def map_coordinates(crime_codes = [])
    if crime_codes.present?
      service_url = URI::escape("#{RESOURCE_URL}?$where= #{query_polygon} AND #{process_crime_filters(crime_codes)}")
    else
      service_url = URI::escape("#{RESOURCE_URL}?$where= #{query_polygon}")
    end

    mapify_coordinates(HTTParty.get(service_url, verify: false))
  end

  def grouped_totals
    service_url = URI::escape("#{RESOURCE_URL}?$where=#{query_polygon}&$select=ibrs,count(ibrs)&$group=ibrs")
    crimes = HTTParty.get(service_url, verify: false)

    binding.pry

    crime_counts = crimes.inject({}) {|crime_hash, crime|
      crime_hash.merge(crime['ibrs'] => crime['count_ibrs'])
    }

    convert_crime_key_to_application_key(crime_counts)
  end

  private

  def convert_crime_key_to_application_key(crime_counts)
    CrimeMapper::CRIME_CATEGORIES.inject({}) do |result, crime_category|
      crimes = crime_category[1].inject({}) do |crime_hash, crime|
        crime_hash.merge(CrimeMapper::CRIME_CODES[crime] => crime_counts[crime].to_i)
      end

      result.merge(crime_category[0] => crimes)
    end
  end

  def process_crime_filters(crime_codes)
    if crime_codes.present?
      crime_code_filter = crime_codes.join("' OR ibrs='")
      "(ibrs = '#{crime_code_filter}')"
    else
      ""
    end
  end

  def mapify_coordinates(coordinates)
    # Not every coordinate is guaraneed to have location_1 populated with coordinates
    coordinates
      .select{ |coordinate|
        coordinate["location_1"].present? && coordinate["location_1"]["coordinates"].present?
      }
      .map { |coordinate|
        {
          "description" => coordinate['description'],
          "offense" => coordinate['offense'],
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => coordinate["location_1"]["coordinates"]
          }
        }
      }
  end

  def query_polygon
    coordinates = @neighborhood.coordinates.map{ |neighborhood|
      "#{neighborhood.latitude} #{neighborhood.longtitude}"
    }.join(',')

    "within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')"
  end
end
