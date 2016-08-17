class NeighborhoodServices::LegallyAbandonedCalculation::VacantRegistries
  def initialize(vacant_registries_data)
    @vacant_registries_data = vacant_registries_data
  end

  def calculated_data
    @vacant_registries_data.each_with_object({}) do |vacant_lot, points_hash|
      display = "<b>Registration Type:</b> #{vacant_lot['registration_type']}<br/><b>Last Verified: #{vacant_lot['last_verified']}</b>"

      points_hash[vacant_lot['property_address'].downcase] = {
        points: 2,
        longitude: vacant_lot['longitude'],
        latitude: vacant_lot['latitude'],
        disclosure_attributes: [display]
      }
    end
  end
end
