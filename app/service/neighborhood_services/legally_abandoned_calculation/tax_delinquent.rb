class NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent
  START_YEAR = 2018
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    addresses = {}

    @neighborhood.addresses.each do |taxed_address|
      current_address = taxed_address['street_address']

      if current_address.present?
        current_year = START_YEAR
        consecutive_years = 0

        while taxed_address["county_delinquent_tax_#{current_year}"].to_f > 0 do
          consecutive_years += 1
          current_year -= 1
        end

        addresses[current_address.downcase] = {
          source: @neighborhood.address_source_uri,
          tax_delinquent_source: URI::escape("tax_delinquency/#{taxed_address['county_id']}"),
          longitude: taxed_address['census_longitude'].to_f,
          latitude: taxed_address['census_latitude'].to_f,
          consecutive_years: consecutive_years,
          zip: taxed_address['zip'],
          city: taxed_address['city'],
          state: taxed_address['state'],
          owner: taxed_address['county_owner'].try(&:titleize)
        }
      end
    end

    addresses
  end
end
