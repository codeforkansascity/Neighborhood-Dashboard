require 'kcmo_datasets/dangerous_buildings'

class NeighborhoodServices::VacancyData::DangerousBuildings
  POSSIBLE_FILTERS = ['dangerous_building']

 def initialize(neighborhood, filters = {})
    @neighborhood = neighborhood
    @filters = filters[:filters] || []
    @start_date = filters[:start_date]
    @end_date = filters[:end_date]
  end

  def data
    return @data unless @data.nil?

    querable_dataset = POSSIBLE_FILTERS.any? { |filter|
      @filters.include? filter
    }

    if querable_dataset
      @data ||= query_dataset
    else
      @data ||= []
    end
  end

  private 

  def query_dataset
    dangerous_buildings = ::KcmoDatasets::DangerousBuildings.new(@neighborhood).request_data

    dangerous_buildings
      .select { |building|
        building['location'].present?
      }
      .map { |building|
        {
          'type' => 'Feature',
          'geometry' => building['location'],
          'properties' => {
            'color' => '#ffffff',
            'disclosure_attributes' => [
              "<h2 class='info-window-header'>Dangerous Building Case of #{building['statusofcase']}</h2>"
            ]
          }
        }
      }
  end
end