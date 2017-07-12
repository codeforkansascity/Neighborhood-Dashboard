class NeighborhoodServices::FilteredVacantData
  def initialize(neighborhood)
    @neighborhood = neighborhood
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

    data = []

    if contains?(filters, NeighborhoodServices::VacancyData::TaxDelinquent::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::TaxDelinquent.new(@neighborhood, filters_copy).data
    end

    if contains?(filters, NeighborhoodServices::VacancyData::DangerousBuildings::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::DangerousBuildings.new(@neighborhood, filters_copy).data
    end

    if contains?(filters, NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::LandBank.new(@neighborhood, filters_copy).data
    end

    if contains?(filters, NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::ThreeEleven.new(@neighborhood, filters_copy).data 
    end

    if contains?(filters, NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS)
      data << NeighborhoodServices::VacancyData::PropertyViolations.new(@neighborhood, filters_copy).data
    end

    data
  end

  private

  def contains?(dataset_filters, user_filters)
    (dataset_filters & user_filters).size > 0
  end
end
