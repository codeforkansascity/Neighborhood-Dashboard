require 'kcmo_datasets/crime'

class NeighborhoodServices::Crime
  def initialize(neighborhood_id, options = {})
    @neighborhood_id = neighborhood_id
    @options = options
  end

  def grouped_totals
    @dataset ||= KcmoDatasets::Crime.new(Neighborhood.find(@neighborhood_id), @options)
    CrimeMapper.convert_crime_key_to_application_key(@dataset.grouped_totals)
  end

  def mapped_coordinates
    @dataset ||= KcmoDatasets::Crime.new(Neighborhood.find(@neighborhood_id), @options)
    mapify_coordinates(@dataset.query_data)
  end

  private

  def mapify_coordinates(coordinates)
    # Not every coordinate is guaraneed to have location_1 populated with
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
            "disclosure_attributes" => all_disclosure_attributes(coordinate)
          }
        }
      }
  end

  def all_disclosure_attributes(coordinate)
    crime_date_text = begin
                        "Committed on #{DateTime.parse(coordinate['from_date']).strftime('%m/%d/%Y')}"
                      rescue
                        "Committed in #{coordinate['dataset_year']}"
                      end

    [
      coordinate['description'],
      coordinate['address'].try(:titleize),
      crime_date_text,
      "<a href=#{coordinate['source']}>Data Source</a>",
      "Last Updated: #{coordinate['last_updated']}"
    ]
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
end
