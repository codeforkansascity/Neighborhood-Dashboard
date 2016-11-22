class NeighborhoodServices::LegallyAbandonedCalculation::VacantRegistries
  SOURCE_URI = 'http://webfusion.kcmo.org/coldfusionapps/neighborhood/rentalreg/PropList.cfm'

  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculated_data
    vacant_registries_data = StaticData::VACANT_LOT_DATA().select{ |lot| lot['neighborhood'] == @neighborhood.name }

    vacant_registries_data.each_with_object({}) do |vacant_lot, points_hash|
      display = "<b>Registration Type:</b> #{vacant_lot['registration_type']}<br/><b>Last Verified:</b> #{vacant_lot['last_verified']}"
      header = "<h2 class='info-window-header'>Registered Vacant</h2>&nbsp:<a href='#{SOURCE_URI}'>Source</a>"
  
      points_hash[vacant_lot['property_address'].downcase] = {
        points: 2,
        longitude: vacant_lot['longitude'],
        latitude: vacant_lot['latitude'],
        disclosure_attributes: [header, display]
      }
    end
  end
end
