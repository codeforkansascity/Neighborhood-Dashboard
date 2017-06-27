module Entities::LandBankData
  class LandBank < ::Entities::GeoJson
    attr_accessor :property_class, :potential_use, :property_condition, :parcel_number

    def disclosure_attributes
      [
        "<b>Property Class:</b> #{property_class}",
        "<b>Potential Use:</b> #{potential_use}",
        "<b>Property Condition:</b> #{property_condition}"
      ]
    end
  end
end
