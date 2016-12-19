module CensusData
  class CityAverages
    attr_reader :average_totals

    def initialize
      census_data = StaticData.CENSUS_DATA().values
      hood_count = census_data.length
      
      census_years = census_data.first.keys

      @average_totals = census_years.each_with_object({}) do |year, hash|
        census_keys = census_data.first[year].keys
        hash[year] = {}

        census_keys.each do |current_key|
          hash[year][current_key] = (census_data.sum { |hood| hood[year][current_key].to_f }).to_i
        end

        hash
      end
    end
  end
end