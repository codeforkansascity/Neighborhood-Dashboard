class NeighborhoodServices::VacancyData::ThreeEleven
  DATA_URL = 'https://data.kcmo.org/resource/7at3-sxhp.json'
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
      @data ||= []
    else
      @data ||= query_dataset
    end
  end

  private

  def query_dataset
    request_url = URI::escape("#{DATA_URL}?$query=#{build_socrata_query}")
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
            "coordinates" => [parcel["address_with_geocode"]["longitude"].to_f, parcel["address_with_geocode"]["latitude"].to_f]
          },
          "properties" => {
            "parcel_number" => parcel['parcel_number'],
            "color" => '#ffffff',
            "disclosure_attributes" => parcel['disclosure_attributes'].uniq
          }
        }
      }
  end

  def build_socrata_query
    query_string = "SELECT * where neighborhood = '#{@neighborhood.name}'"
    query_elements = []

    if @three_eleven_filters.include?('vacant_structure')
      query_elements << "request_type='Nuisance Violations on Private Property Vacant Structure'"
      query_elements  << "request_type='Vacant Structure Open to Entry'"
    end

    if @three_eleven_filters.include?('open')
      query_elements << "status='OPEN'"
    end

    if query_elements.present?
      query_string += " AND (#{query_elements.join(' or ')})"
    end

    if @start_date && @end_date
      begin
        query_string += " AND creation_date >= '#{DateTime.parse(@start_date).iso8601[0...-6]}'"
        query_string += " AND creation_date <= '#{DateTime.parse(@end_date).iso8601[0...-6]}'"
      rescue
      end
    end

    query_string
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
      if data[entity['parcel_id_no']]
        data[entity['parcel_id_no']]['disclosure_attributes'] += entity['disclosure_attributes']
      else
        data[entity['parcel_id_no']] = entity
      end
    end
  end
end
