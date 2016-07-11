class NeighborhoodServices::VacancyData::PropertyViolations
  DATA_URL = 'https://data.kcmo.org/resource/nhtf-e75a.json'
  POSSIBLE_FILTERS = ['all_property_violations']

  def initialize(neighborhood, property_violation_filters = {})
    @neighborhood = neighborhood
    @property_violation_filters = property_violation_filters[:filters] || []
    @start_date = property_violation_filters[:start_date]
    @end_date = property_violation_filters[:end_date]
  end

  def data
    return @data unless @data.nil?

    querable_dataset = POSSIBLE_FILTERS.any? { |filter|
      @property_violation_filters.include? filter
    }

    if querable_dataset
      @data ||= query_dataset
    else
      @data ||= []
    end
  end

  private

  def query_dataset
    request_url = URI::escape("#{DATA_URL}?$query=#{build_socrata_query}")
    violation_data = HTTParty.get(request_url, verify: false)

    property_violations_filtered_data(violation_data)
      .values
      .select { |violation|
        violation["mapping_location"].present? && violation["mapping_location"]["latitude"].present?
      }
      .map { |violation|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => [violation["mapping_location"]["longitude"].to_f, violation["mapping_location"]["latitude"].to_f]
          },
          "properties" => {
            "color" => '#ffffff',
            "disclosure_attributes" => all_disclosure_attributes(violation)
          }
        }
      }
  end

  def build_socrata_query
    query_string = "SELECT * where neighborhood = '#{@neighborhood.name}'"
    query_elements = []

    if @property_violation_filters.include?('all_property_violations')
      query_elements << "status='Open'"
    end

    if query_elements.present?
      query_string += " AND (#{query_elements.join(' or ')})"
    end

    if @start_date && @end_date
      begin
        query_string += " AND violation_entry_date >= '#{DateTime.parse(@start_date).iso8601[0...-6]}'"
        query_string += " AND violation_entry_date <= '#{DateTime.parse(@end_date).iso8601[0...-6]}'"
      rescue
      end
    end

    query_string
  end

  def property_violations_filtered_data(violation_data)
    property_violations_filtered_data = {}

    if @property_violation_filters.include?('all_property_violations')
      all_violations_data = ::NeighborhoodServices::VacancyData::Filters::AllPropertyViolations.new(violation_data).filtered_data
      merge_data_set(property_violations_filtered_data, all_violations_data)
    end

    property_violations_filtered_data
  end

  def merge_data_set(data, data_set)
    data_set.each do |entity|
      if data[entity['address']]
        data[entity['address']]['disclosure_attributes'] += entity['disclosure_attributes']
      else
        data[entity['address']] = entity
      end
    end
  end

  def all_disclosure_attributes(violation)
    disclosure_attributes = violation['disclosure_attributes'].try(&:uniq) || []
    address = JSON.parse(violation["mapping_location"]["human_address"])["address"].titleize
    ["<b>Address:</b> #{address}"] + disclosure_attributes
  end
end
