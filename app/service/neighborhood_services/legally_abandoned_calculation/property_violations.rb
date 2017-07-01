class NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    dataset = KcmoDatasets::PropertyViolations.new(@neighborhood)
    property_violations_data = dataset
                               .vacant_registry_failure
                               .boarded_longterm
                               .request_data

    property_violations_data.each_with_object({}) do |violation, hash|
      street_address = violation['address']

      if street_address.present?
        hash[street_address.downcase] = {
          last_updated_date: last_updated_date(dataset.metadata),
          longitude: violation['mapping_location']['coordinates'][0].to_f,
          latitude: violation['mapping_location']['coordinates'][1].to_f,
          violation_description: violation['violation_description']
        }
      end
    end
  end

  private

  def last_updated_date(metadata)
    DateTime.strptime(metadata['viewLastModified'].to_s, '%s').strftime('%m/%d/%Y')
  rescue
    'N/A'
  end
end
