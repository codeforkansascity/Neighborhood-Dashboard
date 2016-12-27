require 'census_data/city_averages'

module CensusData
  class NeighborhoodData
    def initialize(neighborhood)
      @neighborhood = neighborhood
    end

    def fetch_data
      @data = StaticData.CENSUS_DATA()[@neighborhood.name].dup

      @data['working_force_data'] = {
        '2000' => neighborhood_working_force('2000'),
        '2010' => neighborhood_working_force('2010')
      }

      @data['total_city_population'] = {
        "2000" => total_city_population('2000'),
        "2010" => total_city_population('2010')
      }

      @data['total_working_force'] = {
        "2000" => total_working_force('2000'),
        "2010" => total_working_force('2010')
      }
      
      @data['total_housing_units'] = { 
        "2000" => total_housing_units('2000'),
        "2010" => total_housing_units('2010')
      }

      # 2010 Needs to have the same columns as the 2000 data, and thus must be converted.
      convert_housing_data('2010')

      @data['average_city_totals'] = CensusData::CityAverages.new.average_totals
      @data
    end

    private

    def neighborhood_working_force(year)
      {
        'employed' => 
          @data[year]['civilian_16_or_older_males_in_the_labor_force_and_employed'].to_i +
          @data[year]['civilian_16_or_older_females_in_the_labor_force_and_employed'].to_i,
        'unemployed' => 
          @data[year]['civilian_16_or_older_males_in_the_labor_force_but_unemployed'].to_i +
          @data[year]['civilian_16_or_older_females_in_the_labor_force_but_unemployed'].to_i,
        'not_in_workforce' =>
          @data[year]['civilian_16_or_older_males_not_in_the_labor_force'].to_i +
          @data[year]['civilian_16_or_older_females_not_in_the_labor_force'].to_i
      }.tap { |hash| 
        hash['total'] = hash['employed'] + hash['unemployed'] + hash['not_in_workforce']
      }
    end

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

    def convert_housing_data(year)
      @data[year]['households_with_income_$10_000_$19_999'] = 
        @data[year]['households_with_income_$10_000_$14_999'] +
        @data[year]['households_with_income_$15_000_$19_999']

      @data[year]['households_with_income_$20_000_$29_999'] = 
        @data[year]['households_with_income_$20_000_$24_999'] +
        @data[year]['households_with_income_$25_000_$29_999']

      @data[year]['households_with_income_$30_000_$39_999'] = 
        @data[year]['households_with_income_$30_000_$34_999'] +
        @data[year]['households_with_income_$35_000_$39_999']

      @data[year]['households_with_income_$40_000_$49_999'] = 
        @data[year]['households_with_income_$40_000_$44_999'] +
        @data[year]['households_with_income_$45_000_$49_999']
    end

    def total_working_force(year)
      StaticData.CENSUS_DATA().map{ |(k,v)|
        v[year]['civilian_16_or_older_males_in_the_labor_force_and_employed'].to_i + 
        v[year]['civilian_16_or_older_males_in_the_labor_force_but_unemployed'].to_i +
        v[year]['civilian_16_or_older_males_not_in_the_labor_force'].to_i +
        v[year]['civilian_16_or_older_females_in_the_labor_force_and_employed'].to_i + 
        v[year]['civilian_16_or_older_females_in_the_labor_force_but_unemployed'].to_i +
        v[year]['civilian_16_or_older_females_not_in_the_labor_force'].to_i
      }.compact.map(&:to_i).sum
    end
  end
end
