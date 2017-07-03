class NeighborhoodServices::FilteredVacantData
  def initialize(neighborhood_id)
    @neighborhood_id = neighborhood_id
  end

  def neighborhood
    @neighborhood ||= Neighborhood.find(@neighborhood_id)
  end

  def filtered_vacant_data(filters = {})
    filters_copy = filters.dup || {}
    filters = filters_copy['filters'] || []

    if filters.include?('all_property_violations')
      filters += NeighborhoodServices::VacancyData::TaxDelinquent::POSSIBLE_FILTERS
      filters += NeighborhoodServices::VacancyData::DangerousBuildings::POSSIBLE_FILTERS
      filters += NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS
      filters += NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS
      filters += NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS
    end

    current_neighborhood = neighborhood

    data = []

    if contains?(filters, NeighborhoodServices::VacancyData::TaxDelinquent::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::TaxDelinquent.new(current_neighborhood, filters_copy).data
    end

    if contains?(filters, NeighborhoodServices::VacancyData::DangerousBuildings::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::DangerousBuildings.new(current_neighborhood, filters_copy).data
    end

    if contains?(filters, NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::LandBank.new(current_neighborhood, filters_copy).data
    end

    if contains?(filters, NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::ThreeEleven.new(current_neighborhood, filters_copy).data 
    end

    if contains?(filters, NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::PropertyViolations.new(current_neighborhood, filters_copy).data
    end

    data
  end

  private

  def contains?(dataset_filters, user_filters)
    (dataset_filters & user_filters).size > 0
  end
end
