require 'census_data/city_averages'

module CensusData
  class NeighborhoodData
    def initialize(neighborhood)
      @neighborhood = neighborhood
    end

    def fetch_data
      @data = StaticData.CENSUS_DATA()[@neighborhood.name].dup

      @data['total_city_population'] = total_city_population
      @data['total_housing_units'] = total_housing_units
      @data['average_city_totals'] = CensusData::CityAverages.new.average_totals
      @data
    end

    private

    def total_city_population
      @total_city_population ||= StaticData.CENSUS_DATA().map{ |(k,v)|
        v['population']
      }.compact.map(&:to_i).sum
    end

    def total_housing_units
      @total_housing_units ||= StaticData.CENSUS_DATA().map{ |(k,v)|
        v['housing_units']
      }.compact.map(&:to_i).sum
    end
  end
end
