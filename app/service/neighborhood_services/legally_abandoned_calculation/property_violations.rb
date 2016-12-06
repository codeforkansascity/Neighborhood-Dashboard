class NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    dataset = KcmoDatasets::PropertyViolations.new(@neighborhood)
    property_violations_data = dataset
                               .vacant_registry_failure
                               .request_data

    property_violations_data.each_with_object({}) do |violation, hash|
      street_address = violation['address']

      if street_address.present?
        header = "<h2 class='info-window-header'>Property Violations:</h2>&nbsp;<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'>Source</a>"
        last_updated = "Last Updated: #{last_updated_date(dataset.metadata)}"

        hash[street_address.downcase] = {
          points: 2,
          longitude: violation['mapping_location']['coordinates'][0].to_f,
          latitude: violation['mapping_location']['coordinates'][1].to_f,
          categories: [NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION],
          disclosure_attributes: [header, last_updated, violation['violation_description'].titleize]
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
