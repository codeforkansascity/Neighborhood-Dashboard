class NeighborhoodServices::VacancyData::ThreeEleven
  DATA_SOURCE = '7at3-sxhp'
  DATA_SOURCE_URI = 'https://data.kcmo.org/311/311-Call-Center-Service-Requests/7at3-sxhp'
  POSSIBLE_FILTERS = ['vacant_structure', 'open_three_eleven']

  def initialize(neighborhood, three_eleven_filters = {})
    @neighborhood = neighborhood
    @three_eleven_filters = three_eleven_filters
  end

  def data
    three_eleven_dataset = KcmoDatasets::ThreeElevenCases.new(@neighborhood, @three_eleven_filters)
    three_eleven_data = three_eleven_dataset.request_data

    data = three_eleven_filtered_data(three_eleven_data)
      .values
      .each { |violation| 
        violation.metadata = three_eleven_dataset.metadata
      }
      .select(&Entities::GeoJson::MAPPABLE_ITEMS)

    data
  end

  private

  def three_eleven_filtered_data(parcel_data)
    three_eleven_filtered_data = {}
    data_filters = @three_eleven_filters[:filters] || []

    if data_filters.include?('vacant_structure')
      vacant_structure_data = ::NeighborhoodServices::VacancyData::Filters::VacantStructure.new(parcel_data).filtered_data
      vacant_structure_data_entities = vacant_structure_data.map { |land_bank| ::Entities::ThreeEleven::VacantStructure.deserialize(land_bank) }
      merge_data_set(three_eleven_filtered_data, vacant_structure_data_entities)
    end

    if data_filters.include?('open_three_eleven')
      open_case_data = ::NeighborhoodServices::VacancyData::Filters::OpenThreeEleven.new(parcel_data).filtered_data
      open_case_data_entities = open_case_data.map { |land_bank| ::Entities::ThreeEleven::OpenCase.deserialize(land_bank) }
      merge_data_set(three_eleven_filtered_data, open_case_data_entities)
    end

    three_eleven_filtered_data
  end

  def merge_data_set(data, data_set)
    data_set.each do |entity|
      data[entity.address] = Entities::ThreeEleven::Cases.new unless data[entity.address]
      data[entity.address].add_dataset(entity)
    end
  end
end
