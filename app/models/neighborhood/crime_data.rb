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

  def map_coordinates(params = {})
    start_date = params[:start_date]
    end_date = params[:end_date]
    crime_codes = params[:crime_codes] || []

    service_url = "#{RESOURCE_URL}?$where= #{query_polygon}"

    if crime_codes.present?
      service_url += " AND #{process_crime_filters(crime_codes)}"
    end

    if start_date && end_date
      begin
        service_url += " AND #{filter_dates(start_date, end_date)}"
      rescue ArgumentError
      end
    end

    mapify_coordinates(HTTParty.get(URI::escape(service_url), verify: false))
  end

  def grouped_totals
    service_url = URI::escape("#{RESOURCE_URL}?$where=#{query_polygon}&$select=ibrs,count(ibrs)&$group=ibrs")
    crimes = HTTParty.get(service_url, verify: false)

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
          "ibrs" => coordinate['ibrs'],
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => coordinate["location_1"]["coordinates"]
          },
          "properties" => {
            "color" => crime_marker_color(coordinate['ibrs']),
            "disclosure_attributes" => disclosure_attributes(coordinate)
          }
        }
      }
  end

  def disclosure_attributes(coordinate)
    [coordinate['description'] + '<br/>' + DateTime.parse(coordinate['from_date']).strftime("%m/%d/%Y")]
  rescue ArgumentError
    puts 'Invalid Date Format Provided'
    [coordinate['description']]
  end

  def crime_marker_color(ibrs)
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

  def query_polygon
    coordinates = @neighborhood.coordinates.map{ |neighborhood|
      "#{neighborhood.longtitude} #{neighborhood.latitude}"
    }.join(',')

    "within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')"
  end

  def filter_dates(start_date, end_date)
    "from_date between '#{DateTime.parse(start_date).iso8601[0...-6]}' and '#{DateTime.parse(end_date).iso8601[0...-6]}'"
  end
end
