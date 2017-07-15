class NeighborhoodServices::MiscellaneousData::SidewalkData
  POSSIBLE_FILTERS = ['sidewalk_issues']

  def initialize(neighborhood, filters = {})
    @neighborhood = neighborhood
    @filters = filters
  end

  def data
    three_eleven_dataset = KcmoDatasets::ThreeElevenCases.new(@neighborhood, @filters)
    sidewalk_data = three_eleven_dataset.request_data

    data = sidewalk_data
      .map { |violation| 
        entity = Entities::ThreeEleven::Sidewalk.deserialize(violation)
        entity.metadata = three_eleven_dataset.metadata
        entity
      }
      .select(&Entities::GeoJson::MAPPABLE_ITEMS)

    data
  end
end
