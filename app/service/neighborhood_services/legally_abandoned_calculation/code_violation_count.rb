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
        current_violation_count = address['count_address'].to_i

        points = if current_violation_count >= 3
                   2
                 elsif current_violation_count >= 2
                   1
                 else
                   0
                 end

        header = "<h2 class='info-window-header'>Code Violation Count</h2>&nbsp;<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'><small>(Source)</small></a>"
        message = "#{current_violation_count} Code Violations"

        if points > 0
          addresses[mapping_address.downcase] = {
            points: points,
            longitude: address['mapping_location']['coordinates'][0].to_f,
            latitude: address['mapping_location']['coordinates'][1].to_f,
            categories: [NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION],
            disclosure_attributes: [header, message]
          }
        end
      end
    end

    addresses
  end
end