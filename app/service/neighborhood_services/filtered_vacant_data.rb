class NeighborhoodServices::FilteredVacantData
  def initialize(neighborhood_id)
    @neighborhood_id = neighborhood_id
  end

  def neighborhood
    @neighborhood ||= Neighborhood.find(@neighborhood_id)
  end

  def filtered_vacant_data(filters = {})
    filters_copy = filters.dup || {}

    if filters_copy['filters'].include?('all_property_violations')
      filters_copy['filters'] += NeighborhoodServices::VacancyData::TaxDelinquent::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::DangerousBuildings::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS
    end

    threads = []
    data = []

    current_neighborhood = neighborhood

    threads << Thread.new do
      data += NeighborhoodServices::VacancyData::TaxDelinquent.new(current_neighborhood, filters_copy).data
    end

    threads << Thread.new do
      data += NeighborhoodServices::VacancyData::DangerousBuildings.new(current_neighborhood, filters_copy).data
    end

    threads << Thread.new do
      data += NeighborhoodServices::VacancyData::LandBank.new(current_neighborhood, filters_copy).data
    end

    threads << Thread.new do
      data += NeighborhoodServices::VacancyData::ThreeEleven.new(current_neighborhood, filters_copy).data 
    end

    threads << Thread.new do
      data += NeighborhoodServices::VacancyData::PropertyViolations.new(current_neighborhood, filters_copy).data
    end


    threads.map(&:join)
    data
  end
end
