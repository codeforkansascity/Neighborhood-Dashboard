class NeighborhoodServices::VacancyData::VacantLotRegistry
  def initialize(neighborhood, vacant_lot_registry_filters = {})
    @neighborhood = neighborhood
    @vacant_lot_registry_filters = vacant_lot_registry_filters[:filters] || []
    @start_date = vacant_lot_registry_filters[:start_date]
    @end_date = vacant_lot_registry_filters[:end_date]
  end

  def data
    @data ||= query_dataset
  end

  private

  def query_dataset
    @neighborhood.registered_vacant_lots.map { |vacant_lot|
      {
        "type" => "Feature",
        "geometry" => {
          "type" => "Point",
          "coordinates" => [vacant_lot.longitude, vacant_lot.latitude]
        },
        "properties" => {
          "color" => '#ffffff',
          "disclosure_attributes" => [
            "<b>Address</b>: #{vacant_lot.property_address}",
            "<b>Owner:</b> #{vacant_lot.contact_person}",
            "<b>Phone Number:</b> #{vacant_lot.contact_phone}",
            "<b>Registration Type:</b> #{vacant_lot.registration_type}", 
            "<b>Last Verified:</b> #{get_date(vacant_lot.last_verified)}"
          ]
        }
      }
    }.reject { |vacant_lot|
      vacant_lot["geometry"]["coordinates"].nil?
    }
  end

  def get_date(date)
    date.strftime("%m/%d/%y")
  rescue
    "N/A"
  end
end
