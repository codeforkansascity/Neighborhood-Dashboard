class NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    addresses = {}

    code_violation_data = KcmoDatasets::PropertyViolations.grouped_address_counts(@neighborhood)
    code_violation_data.each do |address|
      mapping_address = address['address']

      if mapping_address.present?
        addresses[mapping_address.downcase] = {
          violation_count: current_violation_count = address['count_address'].to_i,
          longitude: address['mapping_location']['coordinates'][0].to_f,
          latitude: address['mapping_location']['coordinates'][1].to_f,
        }
      end
    end

    addresses
  end
end
