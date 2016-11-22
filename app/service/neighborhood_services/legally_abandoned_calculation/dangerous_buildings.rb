class NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    dangerous_building_data = KcmoDatasets::DangerousBuildings.new(@neighborhood).request_data

    dangerous_building_data.each_with_object({}) do |dangerous_building, points_hash|
      address = dangerous_building['address']
      source_link = "<a href='#{KcmoDatasets::DangerousBuildings::SOURCE_URI}'>Source</a>"

      if address.present?
        points_hash[address.downcase] = {
          points: 2,
          longitude: dangerous_building['location']['coordinates'][0].to_f,
          latitude: dangerous_building['location']['coordinates'][1].to_f,
          disclosure_attributes: [
            "<h2 class='info-window-header'>Dangerous Building</h2>&nbsp;#{source_link}",
            dangerous_building['statusofcase']
          ]
        }
      end
    end
  end
end
