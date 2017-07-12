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
    dataset = ::KcmoDatasets::DangerousBuildings.new(@neighborhood)
    dangerous_buildings = dataset.request_data
    metadata = dataset.metadata

    @data = dangerous_buildings
      .map{ |building|
        entity = Entities::Vacancy::DangerousBuilding.deserialize(building)
        entity.metadata = metadata
        entity
      }
      .select(&Entities::GeoJson::MAPPABLE_ITEMS)

    @data
  end
end
