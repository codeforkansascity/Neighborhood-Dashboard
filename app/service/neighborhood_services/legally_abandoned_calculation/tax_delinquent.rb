class NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent
  def initialize(tax_delinquent_data)
    @tax_delinquent_data = tax_delinquent_data
  end

  def calculated_data
    addresses = {}
    possible_years = [2015, 2014, 2013, 2012]

    @tax_delinquent_data.each do |taxed_address|
      current_address = taxed_address['street_address']

      if current_address.present?
        consecutive_years = 0

        possible_years.each do |year|
          if taxed_address["county_delinquent_tax_#{year}"].to_f > 0
            consecutive_years += 1
          else
            break
          end
        end

        points = if consecutive_years >= 3
                   2
                 elsif consecutive_years >= 1
                   1
                 else
                   0
                 end

        delinquent_message = consecutive_years > 0 ? "#{consecutive_years} years(s) Vacant" : nil

        if points > 0
          addresses[current_address.downcase] = {
            points: points,
            longitude: taxed_address['census_longitude'],
            latitude: taxed_address['census_latitude'],
            disclosure_attributes: [delinquent_message]
          }
        end
      end
    end

    addresses
  end
end
