class NeighborhoodServices::VacancyData::PropertyViolations
  DATA_SOURCE = 'nhtf-e75a'
  DATA_SOURCE_URI = 'https://data.kcmo.org/Housing/Property-Violations/nhtf-e75a'
  POSSIBLE_FILTERS = ['open_cases', 'vacant_registry_failure', 'boarded_longterm']

  def initialize(neighborhood, property_violation_filters = {})
    @neighborhood = neighborhood
    @filters = property_violation_filters
  end

  def data
    return @data unless @data.nil?

    data_filters = @filters[:filters] || []

    querable_dataset = POSSIBLE_FILTERS.any? { |filter|
      data_filters.include? filter
    }

    if querable_dataset
      @data ||= query_dataset
    else
      @data ||= []
    end
  end

  private

  def query_dataset
    dataset = KcmoDatasets::PropertyViolations.new(@neighborhood, @filters)
    metadata = dataset.metadata

    property_violations_filtered_data(dataset.request_data)
      .values
      .each { |violation| violation.metadata = metadata }
      .map(&:to_h)
  end

  def property_violations_filtered_data(violation_data)
    property_violations_filtered_data = {}
    property_violation_filters = @filters[:filters] || []

    if property_violation_filters.include?('open_cases')
      all_violations_data = ::NeighborhoodServices::VacancyData::Filters::AllPropertyViolations.new(violation_data).filtered_data
      all_violations_data_entities = all_violations_data.map{ |violation| ::Entities::PropertyViolations::Violation.deserialize(violation) }
      merge_data_set!(property_violations_filtered_data, all_violations_data_entities)
    end

    if property_violation_filters.include?('vacant_registry_failure')
      vacant_registry_failure_data = ::NeighborhoodServices::VacancyData::Filters::VacantRegistryFailure.new(violation_data).filtered_data
      vacant_registry_failure_entities = vacant_registry_failure_data.map{ |violation| ::Entities::PropertyViolations::VacantRegistryFailure.deserialize(violation) }
      merge_data_set!(property_violations_filtered_data, vacant_registry_failure_entities)
    end

    if property_violation_filters.include?('boarded_longterm')
      boarded_longterm_data = ::NeighborhoodServices::VacancyData::Filters::BoardedLongterm.new(violation_data).filtered_data
      boarded_longterm_data_entities = boarded_longterm_data.map{ |violation| ::Entities::PropertyViolations::BoardedLongterm.deserialize(violation) }
      merge_data_set!(property_violations_filtered_data, boarded_longterm_data_entities)
    end

    property_violations_filtered_data
  end

  def merge_data_set!(data, data_set)
    data_set.each do |entity|
      data[entity.address] = Entities::PropertyViolations::Violations.new unless data[entity.address]
      data[entity.address].add_dataset(entity)
    end
  end
end
