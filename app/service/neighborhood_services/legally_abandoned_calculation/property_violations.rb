class NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations
  def initialize(property_violations_data)
    @property_violations_data = property_violations_data
  end

  def calculated_data
    @property_violations_data.each_with_object({}) do |violation, hash|
      street_address = violation['address'].downcase

      if street_address
        hash[street_address] = {
          points: 1,
          longitude: violation['mapping_location']['coordinates'][1].to_f,
          latitude: violation['mapping_location']['coordinates'][0].to_f,
          disclosure_attributes: [violation['violation_description'].titleize]
        }
      end
    end
  end
end
