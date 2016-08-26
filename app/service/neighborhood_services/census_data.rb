class NeighborhoodServices::CensusData
  def initialize(neighborhood_id)
    @neighborhood_id = neighborhood_id
  end

  def fetch_data
    neighborhood = Neighborhood.find(@neighborhood_id)
    StaticData.CENSUS_DATA()[neighborhood.name]
  end
end
