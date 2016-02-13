class Neighborhood::VacancyData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def vacant_lots
    request_url = URI::escape("https://data.kcmo.org/resource/2ebw-sp7f.json?$where=neighborhood = '#{@neighborhood.name}'")
    vacancy_coordinates = HTTParty.get(request_url, verify: false)
    vacancy_coordinates
      .select { |coordinate|
        coordinate["location_1"].present? && coordinate["location_1"]["latitude"].present?
      }
      .map { |coordinate|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => [coordinate['location_1']['longitude'].to_f, coordinate['location_1']['latitude'].to_f]
          },
          "properties" => {
            "color" => vacant_lot_color(coordinate),
            "description" => vacant_lot_description(coordinate)
          }
        }
      }
  end

  def dangerous_buildings
    request_url = URI::escape("https://data.kcmo.org/resource/w6zu-4g2q.json?$where=neighborhood = '#{@neighborhood.name}'")
    mapify_coordinates(HTTParty.get(request_url, verify: false))
  end

  private

  def vacant_lot_color(vacant_lot)
    case Date.today.mjd - Date.parse(vacant_lot['acquisition_date']).mjd
    when 0...364
      '#A3F5FF'
    when 365...1094
      '#3A46B2'
    else
      '#000000'
    end
  rescue ArgumentError
    '#ffffff'
  end

  def vacant_lot_description(coordinate)
    description =
      "<h2>#{coordinate['property_condition']}</h2>" +
      "<p>#{coordinate['property_class']}</p>"

    if coordinate['foreclosure_year']
      description += "<p><b>Foreclosure Year:</b> #{coordinate['foreclosure_year']}</p>"
    end

    description
  end

  def mapify_coordinates(coordinates)
    # Not every coordinate is guaraneed to have location_1 populated with coordinates
    coordinates
      .select{ |coordinate|
        coordinate["location_1"].present? && coordinate["location_1"]["latitude"].present?
      }
      .map { |coordinate|
        {
          "property_class" => coordinate['property_class'],
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => [coordinate['location_1']['longitude'].to_f,coordinate['location_1']['latitude'].to_f]
          },
          "properties" => {
            "color" => "#f28729",
          }
        }
      }
  end

  # TODO: Fix API to use this value
  def query_polygon
    coordinates = @neighborhood.coordinates.map{ |neighborhood|
      "#{neighborhood.latitude} #{neighborhood.longtitude}"
    }.join(',')

    "within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')"
  end
end
