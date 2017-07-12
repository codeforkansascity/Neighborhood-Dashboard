require 'kcmo_datasets/three_eleven_cases'

class NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    dataset = KcmoDatasets::ThreeElevenCases.new(@neighborhood)
    three_eleven_data = dataset
                        .open_cases
                        .vacant_called_in_violations
                        .request_data

    three_eleven_data.each_with_object({}) do |violation, hash|
      street_address = violation['street_address'].downcase

      if street_address
        if hash[street_address]
          hash[street_address][:violations] << violation['request_type']
        else
          source_link = "<a href='#{KcmoDatasets::ThreeElevenCases::SOURCE_URI}' target='_blank'><small>(Source)</small></a>"
          hash[street_address] = {
            violations: [violation['request_type']],
            longitude: violation['address_with_geocode']['coordinates'][0].to_f,
            latitude: violation['address_with_geocode']['coordinates'][1].to_f,
            last_updated_date: last_updated_date(dataset.metadata)
          }
        end
      end
    end
  end

  def last_updated_date(metadata)
    DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
  rescue
    'N/A'
  end
end
