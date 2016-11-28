require 'socrata_client'

class NeighborhoodServices::VacancyData::LandBank
  DATA_SOURCE = '2ebw-sp7f'
  DATA_SOURCE_URI = 'https://data.kcmo.org/Property/Land-Bank-Data/2ebw-sp7f'
  POSSIBLE_FILTERS = ['foreclosed', 'demo_needed', 'all_vacant_filters']

  def initialize(neighborhood, vacant_filters = {})
    @neighborhood = neighborhood
    @vacant_filters = vacant_filters[:filters] || []
    @start_date = vacant_filters[:start_date]
    @end_date = vacant_filters[:end_date]
  end

  def data
    return @data unless @data.nil?

    querable_dataset = POSSIBLE_FILTERS.any? { |filter|
      @vacant_filters.include? filter
    }

    if querable_dataset
      @data ||= query_dataset
    else
      @data ||= []
    end
  end

  private

  def query_dataset
    parcel_data = SocrataClient.get(DATA_SOURCE, build_socrata_query)

    parcel_ids = parcel_data.map { |parcel| parcel['parcel_number'] }
    parcels = StaticData::PARCEL_DATA().select { |parcel| parcel_ids.include?(parcel['properties']['apn']) }

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
            "disclosure_attributes" => all_disclosure_attributes(parcel)
          }
        }
      }.reject { |parcel|
        parcel["geometry"]["coordinates"].size == 0
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

  def geometric_parcel_coordinates(parcels, parcel)
    desired_parcel = parcels.find { |current_parcel| current_parcel['properties']['apn'] == parcel['parcel_number'] }

    if desired_parcel.present? 
      desired_parcel["geometry"]["coordinates"][0]
    else
      []
    end
  end

  def build_socrata_query
    query_string = "SELECT * where neighborhood = '#{@neighborhood.name}'"
    query_elements = []

    unless @vacant_filters.include?('all_vacant_filters')
      if @vacant_filters.include?('demo_needed')
        query_elements << "demo_needed='Y'"
      end

      if @vacant_filters.include?('foreclosed')
        query_elements << "(foreclosure_year IS NOT NULL)"
      end
    end

    if query_elements.present?
      query_string += " AND (#{query_elements.join(' or ')})"
    end

    if @start_date && @end_date
      begin
        query_string += " AND acquisition_date >= '#{DateTime.parse(@start_date).iso8601[0...-6]}'"
        query_string += " AND acquisition_date <= '#{DateTime.parse(@end_date).iso8601[0...-6]}'"
      rescue
      end
    end

    query_string
  end

  def land_bank_filtered_data(parcel_data)
    land_bank_filtered_data = {}

    if @vacant_filters.include?('foreclosed')
      foreclosure_data = ::NeighborhoodServices::VacancyData::Filters::Foreclosure.new(parcel_data).filtered_data
      merge_data_set(land_bank_filtered_data, foreclosure_data)
    end

    if @vacant_filters.include?('demo_needed')
      demo_needed_data = ::NeighborhoodServices::VacancyData::Filters::DemoNeeded.new(parcel_data).filtered_data
      merge_data_set(land_bank_filtered_data, demo_needed_data)
    end

    if @vacant_filters.include?('all_vacant_filters')
      all_vacant_lots_data = ::NeighborhoodServices::VacancyData::Filters::AllVacantLots.new(parcel_data).filtered_data
      merge_data_set(land_bank_filtered_data, all_vacant_lots_data)
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

  def all_disclosure_attributes(violation)
    disclosure_attributes = violation['disclosure_attributes'].try(&:uniq) || []
    title = "<h3 class='info-window-header'>Land Bank Data:</h3>&nbsp;<a href='#{DATA_SOURCE_URI}'>Source</a>"
    last_updated = "Last Updated Date: #{last_updated_date}"
    address = "<b>Address:</b>&nbsp;#{JSON.parse(violation['location_1']['human_address'])['address'].titleize}"
    [title, last_updated, address] + disclosure_attributes
  end

  private

  def last_updated_date
    metadata = JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/2ebw-sp7f/').response.body)
    DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
  rescue
    'N/A'
  end
end
