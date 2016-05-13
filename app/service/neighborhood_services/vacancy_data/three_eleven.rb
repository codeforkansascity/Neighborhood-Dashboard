class NeighborhoodServices::VacancyData::ThreeEleven
  DATA_URL = 'https://data.kcmo.org/resource/7at3-sxhp.json'

  def initialize(neighborhood, three_eleven_filters = {})
    @neighborhood = neighborhood
    @vacant_filters = three_eleven_filters[:three_eleven_codes] || []
  end

  def data
    @data ||= query_dataset
  end

  private

  def query_dataset
    request_url = URI::escape("#{DATA_URL}?$where=neighborhood = '#{@neighborhood.name}'")
    three_eleven_data = HTTParty.get(request_url, verify: false)

    three_eleven_filtered_data(three_eleven_data)
      .values
      .select { |parcel|
        parcel["address_with_geocode"].present? && parcel["address_with_geocode"]["latitude"].present?
      }
      .map { |parcel|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => [parcel["address_with_geocode"]["longitude"], parcel["address_with_geocode"]["latitude"]]
          },
          "properties" => {
            "parcel_number" => parcel['parcel_number'],
            "color" => land_bank_color(parcel),
            "disclosure_attributes" => parcel['disclosure_attributes'].uniq
          }
        }
      }
  end

  def land_bank_color(vacant_lot)
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

  def three_eleven_filtered_data(parcel_data)
    three_eleven_filtered_data = {}

    if @vacant_filters.include?('vacant_structure')
      foreclosure_data = ::NeighborhoodServices::VacancyData::Filters::VacantStructure.new(parcel_data).filtered_data
      merge_data_set(three_eleven_filtered_data, foreclosure_data)
    end

    if @vacant_filters.include?('open')
      open_case_data = ::NeighborhoodServices::VacancyData::Filters::OpenThreeEleven.new(parcel_data).filtered_data
      merge_data_set(three_eleven_filtered_data, open_case_data)
    end

    default_disclosure_attributes(three_eleven_filtered_data)
  end

  def merge_data_set(data, data_set)
    data_set.each do |entity|
      if data[entity['parcel_id_no']]
        data[entity['parcel_id_no']]['disclosure_attributes'] += entity['disclosure_attributes']
      else
        data[entity['parcel_id_no']] = entity
      end
    end
  end

  def default_disclosure_attributes(land_bank_data)
    land_bank_data.dup.each { |kiva, land_bank|
      land_bank['disclosure_attributes'] = [
        "<b>Property Class:</b> #{land_bank['property_class']}",
        "<b>Potential Use:</b> #{land_bank['potential_use']}",
        "<b>Property Condition:</b> #{land_bank['property_condition']}"
      ] + land_bank['disclosure_attributes']
    }
  end
end
