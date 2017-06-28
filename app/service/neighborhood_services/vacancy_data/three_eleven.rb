class NeighborhoodServices::VacancyData::ThreeEleven
  DATA_SOURCE = '7at3-sxhp'
  DATA_SOURCE_URI = 'https://data.kcmo.org/311/311-Call-Center-Service-Requests/7at3-sxhp'
  POSSIBLE_FILTERS = ['vacant_structure', 'open']

  def initialize(neighborhood, three_eleven_filters = {})
    @neighborhood = neighborhood
    @three_eleven_filters = three_eleven_filters[:filters] || []
    @start_date = three_eleven_filters[:start_date]
    @end_date = three_eleven_filters[:end_date]
  end

  def data
    return @data unless @data.nil?

    querable_dataset = POSSIBLE_FILTERS.any? { |filter|
      @three_eleven_filters.include? filter
    }

    if querable_dataset
      @data ||= query_dataset
    else
      @data ||= []
    end
  end

  private

  def query_dataset
    three_eleven_data = SocrataClient.get(DATA_SOURCE, build_socrata_query)


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
            "coordinates" => [parcel["address_with_geocode"]["longitude"].to_f, parcel["address_with_geocode"]["latitude"].to_f]
          },
          "properties" => {
            "parcel_number" => parcel['parcel_number'],
            "color" => '#ffffff',
            "disclosure_attributes" => all_disclosure_attributes(parcel)
          }
        }
      }
  end

  def three_eleven_filtered_data(parcel_data)
    three_eleven_filtered_data = {}

    if @three_eleven_filters.include?('vacant_structure')
      foreclosure_data = ::NeighborhoodServices::VacancyData::Filters::VacantStructure.new(parcel_data).filtered_data
      merge_data_set(three_eleven_filtered_data, foreclosure_data)
    end

    if @three_eleven_filters.include?('open')
      open_case_data = ::NeighborhoodServices::VacancyData::Filters::OpenThreeEleven.new(parcel_data).filtered_data
      merge_data_set(three_eleven_filtered_data, open_case_data)
    end

    three_eleven_filtered_data
  end

  def merge_data_set(data, data_set)
    data_set.each do |entity|
      data[entity.address] = Entities::PropertyViolations::Violations.new unless data[entity.address]
      data[entity.address].add_dataset(entity)
    end
  end

  def all_disclosure_attributes(violation)
    disclosure_attributes = violation['disclosure_attributes'].try(&:uniq) || []
    title = "<h3 class='info-window-header'>Three Eleven Data:</h3>&nbsp;<a href='#{DATA_SOURCE_URI}'>Source</a>"
    last_updated = "Last Updated Date: #{last_updated_date}"
    address = "<b>Address:</b>&nbsp;#{JSON.parse(violation['address_with_geocode']['human_address'])['address'].titleize}"
    [title, last_updated, address] + disclosure_attributes
  end

  private

  def last_updated_date
    metadata = JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/7at3-sxhp/').response.body)
    DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
  rescue
    'N/A'
  end
end
