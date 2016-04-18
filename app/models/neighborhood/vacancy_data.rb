class Neighborhood::VacancyData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def vacant_lots
    request_url = URI::escape("https://data.kcmo.org/resource/2ebw-sp7f.json?$where=neighborhood = '#{@neighborhood.name}'")
    parcel_data = HTTParty.get(request_url, verify: false)

    parcel_ids = parcel_data.map { |parcel| parcel['parcel_number'] }
    parcels = StaticData::PARCEL_DATA.select { |parcel| parcel_ids.include?(parcel['properties']['apn']) }

    parcel_data
      .select { |parcel|
        parcel["location_1"].present? && parcel["location_1"]["latitude"].present?
      }
      .map { |parcel|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Polygon",
            "coordinates" => geometric_parcel_coordinates(parcels, parcel)
          },
          "properties" => {
            "color" => vacant_lot_color(parcel),
            "description" => vacant_lot_description(parcel)
          }
        }
      }
  end

  def dangerous_buildings
    request_url = URI::escape("https://data.kcmo.org/resource/w6zu-4g2q.json?$where=neighborhood = '#{@neighborhood.name}'")
    mapify_coordinates(HTTParty.get(request_url, verify: false))
  end

  def legally_abandoned
    code_violations_url = URI::escape("https://data.kcmo.org/resource/nhtf-e75a.json?$where=neighborhood = '#{@neighborhood.name}'")
    code_violations_data = HTTParty.get(code_violations_url, verify: false)

    code_violations = code_violations_data.inject({}) do |result, code_violation|
      if code_violation['mapping_location']['human_address'] && result[code_violation['mapping_location']['human_address']].present?
        result[code_violation['mapping_location']['human_address']].push(code_violation['violation_code'])
        result
      elsif code_violation['id']
        result.merge(code_violation['mapping_location']['human_address'] => [code_violation['violation_code']])
      end
    end

    get_buildings_from_violations(code_violations_data, code_violations)
  end

  private

  def get_buildings_from_violations(code_violations_data, code_violations)
    legally_vagant_ids = code_violations.select do |building_id, violations|
      (violations.include?('NSVACANT') || violations.include?('NSBOARD01')) &&
      (violations - ['NSVACANT', 'NSBOARD01']).size > 0
    end

    legally_vagant_ids.inject({}) { |result, (address, code_violations)|
      result.merge(address => code_violations_data.select{|violation| violation['mapping_location']['human_address'] == address})
    }
  end

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
    # Not every coordinate is guaranteed to have location_1 populated with coordinates
    coordinates
      .select{ |coordinate|
        coordinate['location_1'].present? && coordinate['location_1']['longitude'].present?
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

  def mapify_vacant_buildings(coordinates)
    # Not every coordinate is guaranteed to have mapping_location populated with coordinates
    coordinates
      .select{ |coordinate|
        coordinate['mapping_location'].present? && coordinate['mapping_location']['latitude'].present?
      }
      .map { |coordinate|
        {
          "property_class" => coordinate['property_class'],
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => [coordinate['mapping_location']['longitude'].to_f,coordinate['mapping_location']['latitude'].to_f]
          },
          "properties" => {
            "color" => "#f28729",
          }
        }
      }
  end

  def geometric_parcel_coordinates(parcels, parcel)
    desired_parcel = parcels.find { |current_parcel| current_parcel['properties']['apn'] == parcel['parcel_number'] }

    if desired_parcel.present? 
      desired_parcel["geometry"]["coordinates"][0]
    else
      []
    end
  end

  # TODO: Fix API to use this value
  def query_polygon
    coordinates = @neighborhood.coordinates.map{ |neighborhood|
      "#{neighborhood.latitude} #{neighborhood.longtitude}"
    }.join(',')

    "within_polygon(location_1, 'MULTIPOLYGON (((#{coordinates})))')"
  end
end
