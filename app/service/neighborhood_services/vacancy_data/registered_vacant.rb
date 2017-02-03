class NeighborhoodServices::VacancyData::RegisteredVacant
  POSSIBLE_FILTERS = ['registered_vacant']

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
    vacant_registries = StaticData::VACANT_LOT_DATA().select{ |lot| lot['neighborhood'] == @neighborhood.name }

    vacant_registries
      .map { |vacant_lot|
        {
          'type' => 'Feature',
          'geometry' => {
            'type' => 'Point',
            'coordinates' => [vacant_lot['longitude'].to_f, vacant_lot['latitude'].to_f]
          },
          'properties' => {
            'color' => '#ffffff',
            'disclosure_attributes' => [
              "<h2 class='info-window-header'>Registered Vacant</h2>",
              "Registration Type: #{vacant_lot['registration_type']}<br/>Last Verified: #{vacant_lot['last_verified']}",
              "Owned by #{vacant_lot['contact_person']}<br/>#{vacant_lot['contact_phone']}"
            ]
          }
        }
      }
  end
end
