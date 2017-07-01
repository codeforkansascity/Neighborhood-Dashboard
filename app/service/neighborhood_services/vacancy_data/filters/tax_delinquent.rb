class NeighborhoodServices::VacancyData::Filters::TaxDelinquent
  START_YEAR = 2015

  def initialize(data)
    @addresses = data.dup
  end

  def filtered_data
    neighborhood_addresses = @addresses['data']

    neighborhood_addresses.select { |address|
      consecutive_years = 0
      current_address = address['street_address']

      if current_address.present?
        address['disclosure_attributes'] = []
        possible_years = Array(2012..2016).reverse

        possible_years.each do |year|
          if address["county_delinquent_tax_#{year}"].to_f > 0
            address['disclosure_attributes'] << year
          end
        end
      end

      address['consecutive_years'] = consecutive_years

      if address['disclosure_attributes'].present?
        address['disclosure_attributes'].unshift('<b>Tax Delinquent Years</b>')
        true
      else
        false
      end
    }
  end
end
