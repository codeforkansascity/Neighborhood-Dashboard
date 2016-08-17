class NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount
  def initialize(code_violation_data)
    @code_violation_data = code_violation_data
  end

  def calculated_data
    addresses = {}

    @code_violation_data.each do |address|
      mapping_address = address['mapping_location'].downcase
      if mapping_address.present?
        current_violation_count = address['count_address'].to_i

        points = if current_violation_count >= 3
                   2
                 elsif current_violation_count >= 2
                   1
                 else
                   0
                 end

        message = "#{current_violation_count} Property Violations"

        if points > 0
          addresses[mapping_address] = {
            points: points,
            longitude: address['mapping_location']['coordinates'][0].to_f,
            latitude: address['mapping_location']['coordinates'][1].to_f,
            disclosure_attributes: [message]
          }
        end
      end
    end

    addresses
  end
end
