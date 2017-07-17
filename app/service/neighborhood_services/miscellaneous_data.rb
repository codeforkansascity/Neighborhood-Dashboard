class NeighborhoodServices::MiscellaneousData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def filtered_data(filters = {})
    filters_copy = filters.dup || {}
    data_filters = filters_copy['filters'] || []

    data = []

    if contains?(data_filters, NeighborhoodServices::MiscellaneousData::SidewalkData::POSSIBLE_FILTERS)
      data << NeighborhoodServices::MiscellaneousData::SidewalkData.new(@neighborhood, filters_copy).data
    end

    if contains?(data_filters, NeighborhoodServices::MiscellaneousData::ProblemRenters::POSSIBLE_FILTERS)
      data << NeighborhoodServices::MiscellaneousData::ProblemRenters.new(@neighborhood, filters_copy).data
    end

    data.flatten
  end

  def contains?(dataset_filters, user_filters)
    (dataset_filters & user_filters).size > 0
  end
end
