module CensusData
  class CityAverages
    attr_reader :average_totals

    def initialize
      census_data = StaticData.CENSUS_DATA().values
      hood_count = census_data.length

      neighborhood_keys = census_data.first.keys

      @average_totals = neighborhood_keys.each_with_object({}) do |key, hash|
        hash[key] = (census_data.sum { |hood| hood[key].to_f }).to_i
      end
    end
  end
end