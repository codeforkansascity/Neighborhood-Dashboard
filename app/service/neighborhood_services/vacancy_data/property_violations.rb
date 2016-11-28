class NeighborhoodServices::VacancyData::PropertyViolations
  DATA_SOURCE = 'nhtf-e75a'
  DATA_SOURCE_URI = 'https://data.kcmo.org/Housing/Property-Violations/nhtf-e75a'
  POSSIBLE_FILTERS = ['all_property_violations', 'vacant_registry_failure', 'boarded_longterm']

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
    violation_data = SocrataClient.get(DATA_SOURCE, build_socrata_query)

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
    else
      if @property_violation_filters.include?('vacant_registry_failure')
        query_elements << "violation_code='NSVACANT'"
      end

      if @property_violation_filters.include?('boarded_longterm')
        query_elements << "violation_code='NSBOARD01'"
      end
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
    else
      if @property_violation_filters.include?('vacant_registry_failure')
        vacant_registry_failure_data = ::NeighborhoodServices::VacancyData::Filters::VacantRegistryFailure.new(violation_data).filtered_data
        merge_data_set(property_violations_filtered_data, vacant_registry_failure_data)
      end

      if @property_violation_filters.include?('boarded_longterm')
        boarded_longterm_data = ::NeighborhoodServices::VacancyData::Filters::BoardedLongterm.new(violation_data).filtered_data
        merge_data_set(property_violations_filtered_data, boarded_longterm_data)
      end
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
    title = "<h3 class='info-window-header'>Property Violations:</h3>&nbsp;<a href='#{DATA_SOURCE_URI}'>Source</a>"
    last_updated = "Last Updated Date: #{last_updated_date}"
    address = "<b>Address:</b>&nbsp;#{JSON.parse(violation['mapping_location']['human_address'])['address'].titleize}"
    [title, last_updated, address] + disclosure_attributes
  end

  private

  def last_updated_date
    metadata = JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/nhtf-e75a/').response.body)
    DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
  rescue
    'N/A'
  end
end
