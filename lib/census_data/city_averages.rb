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

        # 2010 Needs to have the same columns as the 2000 data, and thus must be converted.
        if year == "2010"
          convert_housing_data(hash[year])
        end

        hash[year]['work_force_totals'] = work_force_totals(hash[year])
      end
    end

    private

    def convert_housing_data(yearly_data)
      yearly_data['households_with_income_$10_000_$19_999'] = 
        yearly_data['households_with_income_$10_000_$14_999'] +
        yearly_data['households_with_income_$15_000_$19_999']

      yearly_data['households_with_income_$20_000_$29_999'] = 
        yearly_data['households_with_income_$20_000_$24_999'] +
        yearly_data['households_with_income_$25_000_$29_999']

      yearly_data['households_with_income_$30_000_$39_999'] = 
        yearly_data['households_with_income_$30_000_$34_999'] +
        yearly_data['households_with_income_$35_000_$39_999']

      yearly_data['households_with_income_$40_000_$49_999'] = 
        yearly_data['households_with_income_$40_000_$44_999'] +
        yearly_data['households_with_income_$45_000_$49_999']
    end

    def work_force_totals(yearly_data)
      {
        'employed' => 
          yearly_data['civilian_16_or_older_males_in_the_labor_force_and_employed'].to_i +
          yearly_data['civilian_16_or_older_females_in_the_labor_force_and_employed'].to_i,
        'unemployed' => 
          yearly_data['civilian_16_or_older_males_in_the_labor_force_but_unemployed'].to_i +
          yearly_data['civilian_16_or_older_females_in_the_labor_force_but_unemployed'].to_i,
        'not_in_workforce' =>
          yearly_data['civilian_16_or_older_males_not_in_the_labor_force'].to_i +
          yearly_data['civilian_16_or_older_females_not_in_the_labor_force'].to_i
      }.tap { |hash| 
        hash['total'] = hash['employed'] + hash['unemployed'] + hash['not_in_workforce']
      }
    end
  end
end