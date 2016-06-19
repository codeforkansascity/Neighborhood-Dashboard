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
    address_coordinates = {}

    vacant_lots = @neighborhood.addresses['data'].each_slice(999).inject([]) { |results, slice|
      current_query = slice.map { |address|
        if address['single_line_address']
          address_coordinates[address['single_line_address'].split(',')[0].downcase] = 
            [address['census_longitude'].to_f, address['census_latitude'].to_f]

          "UPPER(property_address) LIKE '%#{address['single_line_address'].split(',')[0]}%'"
        else
          nil
        end
      }.compact.join(' OR ')

      results << RegisteredVacantLot.where(current_query)
    }.flatten

    vacant_lots.map { |vacant_lot|
      {
        "type" => "Feature",
        "geometry" => {
          "type" => "Point",
          "coordinates" => address_coordinates[vacant_lot.property_address.downcase]
        },
        "properties" => {
          "color" => '#ffffff',
          "disclosure_attributes" => [
            "<b>Address</b>: #{vacant_lot.property_address}",
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
