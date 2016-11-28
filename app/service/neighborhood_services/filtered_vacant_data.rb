class NeighborhoodServices::FilteredVacantData
  def initialize(neighborhood_id)
    @neighborhood_id = neighborhood_id
  end

  def neighborhood
    @neighborhood = Neighborhood.find(@neighborhood_id)
  end

  def filtered_vacant_data(filters = {})
    filters_copy = filters.dup || {}

    if filters_copy['filters'].include?('all_property_violations')
      filters_copy['filters'] += NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS
      filters_copy['filters'] += ['registered_vacant']
    end

    data =
      NeighborhoodServices::VacancyData::LandBank.new(neighborhood, filters_copy).data + 
      NeighborhoodServices::VacancyData::ThreeEleven.new(neighborhood, filters_copy).data +
      NeighborhoodServices::VacancyData::PropertyViolations.new(neighborhood, filters_copy).data

    data
  end
end
