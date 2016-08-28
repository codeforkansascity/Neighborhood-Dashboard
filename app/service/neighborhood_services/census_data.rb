class NeighborhoodServices::CensusData
  def initialize(neighborhood_id)
    @neighborhood_id = neighborhood_id
  end

  def fetch_data
    neighborhood = Neighborhood.find(@neighborhood_id)
    data = StaticData.CENSUS_DATA()[neighborhood.name]

    data['total_city_population'] = total_city_population
    data['total_housing_units'] = total_housing_units
    data
  end

  private

  def total_city_population
    @total_city_population ||= StaticData.CENSUS_DATA().map{ |(k,v)|
      v['population']
    }.compact.map(&:to_i).sum
  end

  def total_housing_units
    @total_city_population ||= StaticData.CENSUS_DATA().map{ |(k,v)|
      v['housing_units']
    }.compact.map(&:to_i).sum
  end
end
