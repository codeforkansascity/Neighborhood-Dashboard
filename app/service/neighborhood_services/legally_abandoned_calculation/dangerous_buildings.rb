class NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    dataset = KcmoDatasets::DangerousBuildings.new(@neighborhood)
    dangerous_building_data = dataset.request_data

    dangerous_building_data.each_with_object({}) do |dangerous_building, points_hash|
      address = dangerous_building['address']

      if address.present?
        points_hash[address.downcase] = {
          statusofcase: dangerous_building['statusofcase'],
          longitude: dangerous_building['location']['coordinates'][0].to_f,
          latitude: dangerous_building['location']['coordinates'][1].to_f,
          categories: [NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION],
          last_updated_date: last_updated_date(dataset.metadata)
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
