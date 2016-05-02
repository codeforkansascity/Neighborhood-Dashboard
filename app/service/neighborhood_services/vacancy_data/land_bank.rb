class NeighborhoodServices::VacancyData::LandBank
  DATA_URL = 'https://data.kcmo.org/resource/2ebw-sp7f.json'

  def initialize(neighborhood, user_filters = {})
    @neighborhood = neighborhood
    @user_filters = user_filters
  end

  def data
    @data ||= query_dataset
  end

  private

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

  def land_bank_description(coordinate)
    description =
      "<h2>#{coordinate['property_condition']}</h2>" +
      "<p>#{coordinate['property_class']}</p>"

    if coordinate['foreclosure_year']
      description += "<p><b>Foreclosure Year:</b> #{coordinate['foreclosure_year']}</p>"
    end

    description
  end

  def geometric_parcel_coordinates(parcels, parcel)
    desired_parcel = parcels.find { |current_parcel| current_parcel['properties']['apn'] == parcel['parcel_number'] }

    if desired_parcel.present? 
      desired_parcel["geometry"]["coordinates"][0]
    else
      []
    end
  end

  def query_dataset
    request_url = URI::escape("#{DATA_URL}?$where=neighborhood = '#{@neighborhood.name}'")
    parcel_data = HTTParty.get(request_url, verify: false)

    parcel_ids = parcel_data.map { |parcel| parcel['parcel_number'] }
    parcels = StaticData::PARCEL_DATA.select { |parcel| parcel_ids.include?(parcel['properties']['apn']) }

    land_bank_filtered_data(parcel_data)
      .values
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
            "parcel_number" => parcel['parcel_number'],
            "color" => land_bank_color(parcel),
            "disclosure_attributes" => parcel['disclosure_attributes'].uniq
          }
        }
      }
  end

  def land_bank_filtered_data(parcel_data)
    land_bank_filtered_data = {}

    unfiltered_data = ::NeighborhoodServices::VacancyData::Filters::Unfiltered.new(parcel_data).filtered_data
    merge_data_set(land_bank_filtered_data, unfiltered_data)

    if @user_filters['foreclosure_year']
      foreclosure_data = ::NeighborhoodServices::VacancyData::Filters::Foreclosure.new(parcel_data).filtered_data
      merge_data_set(land_bank_filtered_data, foreclosure_data)
    end

    if @user_filters['demo_needed']
      demo_needed_data = ::NeighborhoodServices::VacancyData::Filters::DemoNeeded.new(parcel_data).filtered_data
      merge_data_set(land_bank_filtered_data, demo_needed_data)
    end

    land_bank_filtered_data
  end

  def merge_data_set(data, data_set)
    data_set.each do |entity|
      if data[entity['parcel_number']]
        data[entity['parcel_number']]['disclosure_attributes'] += entity['disclosure_attributes']
      else
        data[entity['parcel_number']] = entity
      end
    end
  end
end
