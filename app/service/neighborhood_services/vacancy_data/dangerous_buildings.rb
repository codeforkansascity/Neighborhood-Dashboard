require 'socrata_client'

class NeighborhoodServices::VacancyData::DangerousBuildings
  DATA_SOURCE = 'rm2v-mbk5'

  def initialize(neighborhood, dangerous_building_filters = {})
    @neighborhood = neighborhood
    @dangerous_building_filters = dangerous_building_filters[:filters] || []
    @start_date = dangerous_building_filters[:start_date]
    @end_date = dangerous_building_filters[:end_date]
  end

  def data
    return @data unless @data.nil?

    if @dangerous_building_filters.include?('dangerous_building')
      @data ||= query_dataset
    else
      @data = []
    end
  end

  private

  def query_dataset
    building_data = SocrataClient.get(DATA_SOURCE, build_socrata_query)

    building_data
      .select { |building|
        building["location"].present?
      }
      .map { |building|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Point",
            "coordinates" => building["location"]["coordinates"]
          },
          "properties" => {
            "color" => '#ffffff',
            "disclosure_attributes" => all_disclosure_attributes(building)
          }
        }
      }.reject { |building|
        building["geometry"]["coordinates"].size == 0
      }
  end

  def build_socrata_query
    "SELECT * where #{@neighborhood.within_polygon_query('location')}"
  end

  def all_disclosure_attributes(building)
    disclosure_attributes = [building['statusofcase']]
  end
end
