class NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    addresses = {}

    code_violation_data = KcmoDatasets::PropertyViolations.new(@neighborhood)
                          .open_cases
                          .request_data

    code_violation_data.each do |address|
      mapping_address = address['address']

      if mapping_address.present?

        # Fix this defect. The 2 should be a 1
        points = if address['days_open'].to_i >= 365 * 3
                   2
                 elsif address['days_open'].to_i >= 365
                   1
                 else
                   0
                 end

        if points > 0
          current_address = address[mapping_address.downcase]

          if current_address.present?
            current_address[:points] = [points, currentAddress[:point]].max
            current_address[:disclosure_attributes] << "address['violation_description'].titleize: #{address['days_open'].to_i % 365} Years open"
          else
            addresses[mapping_address.downcase] = {
              points: points,
              longitude: address['mapping_location']['coordinates'][0].to_f,
              latitude: address['mapping_location']['coordinates'][1].to_f,
              disclosure_attributes: [
                '<h2>Current Violations</h2>',
                "#{address['violation_description'].titleize}: #{(address['days_open'].to_i / 365).floor} Years open"
              ]
            }
          end
        end
      end
    end

    addresses
  end
end
