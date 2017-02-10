class NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent
  START_YEAR = 2015
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    addresses = {}
    start_year = [2015, 2014, 2013, 2012]
    tax_delinquent_data = @neighborhood.addresses['data']

    tax_delinquent_data.each do |taxed_address|
      current_address = taxed_address['street_address']

      if current_address.present?
        current_year = START_YEAR
        consecutive_years = 0

        while taxed_address["county_delinquent_tax_#{current_year}"].to_f > 0 do
          consecutive_years += 1
          current_year -= 1
        end

        points = if consecutive_years >= 3
                   2
                 elsif consecutive_years >= 1
                   1
                 else
                   0
                 end

        if points > 0
          addresses[current_address.downcase] = {
            points: points,
            longitude: taxed_address['census_longitude'].to_f,
            latitude: taxed_address['census_latitude'].to_f,
            categories: [NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION],
            zip: taxed_address['zip'],
            city: taxed_address['city'],
            state: taxed_address['state'],
            owner: taxed_address['county_owner'].try(&:titleize),
            disclosure_attributes: [
              "<h2 class='info-window-header'>Tax Delinquency</h2>&nbsp;<a href='#{@neighborhood.address_source_uri}'><small>(Source)</small></a>",
              "#{consecutive_years} year(s) Tax Delinquent"
            ]
          }
        end
      end
    end

    addresses
  end
end
