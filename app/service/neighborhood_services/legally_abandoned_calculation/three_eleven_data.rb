class NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    three_eleven_data = KcmoDatasets::ThreeElevenCases.new(@neighborhood)
                        .open_cases
                        .vacant_called_in_violations
                        .request_data

    three_eleven_data.each_with_object({}) do |violation, hash|
      street_address = violation['street_address'].downcase

      if street_address
        if hash[street_address]
          hash[street_address][:points] += 1
          hash[street_address][:disclosure_attributes] << violation['request_type']
        else
          hash[street_address] = {
            points: 1,
            longitude: violation['address_with_geocode']['coordinates'][1].to_f,
            latitude: violation['address_with_geocode']['coordinates'][0].to_f,
            disclosure_attributes: [violation['request_type']]
          }
        end
      end
    end
  end
end
