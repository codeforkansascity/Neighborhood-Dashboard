require 'census_data/city_averages'

module CensusData
  class NeighborhoodData
    def initialize(neighborhood)
      @neighborhood = neighborhood
    end

    def fetch_data
      @data = StaticData.CENSUS_DATA()[@neighborhood.name].dup

      @data['total_city_population'] = {
        "2000" => total_city_population('2000'),
        "2010" => total_city_population('2010')
      }
      
      @data['total_housing_units'] = { 
        "2000" => total_housing_units('2000'),
        "2010" => total_housing_units('2010')
      }

      @data['average_city_totals'] = CensusData::CityAverages.new.average_totals
      @data
    end

    private

    def total_city_population(year)
      StaticData.CENSUS_DATA().map{ |(k,v)|
        v[year]['population']
      }.compact.map(&:to_i).sum
    end

    def total_housing_units(year)
      StaticData.CENSUS_DATA().map{ |(k,v)|
        v[year]['housing_units']
      }.compact.map(&:to_i).sum
    end
  end
end
