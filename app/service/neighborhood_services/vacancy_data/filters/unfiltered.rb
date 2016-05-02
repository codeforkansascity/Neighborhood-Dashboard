class NeighborhoodServices::VacancyData::Filters::Unfiltered
  def initialize(land_bank_data)
    @land_bank_data = land_bank_data
  end

  def filtered_data
    @land_bank_data.each { |land_bank|
      if land_bank['disclosure_attributes']
        land_bank['disclosure_attributes'] << "<b>Property Class:</b> #{land_bank['property_class']}"
        land_bank['disclosure_attributes'] << "<b>Potential Use:</b> #{land_bank['potential_use']}"
        land_bank['disclosure_attributes'] << "<b>Property Condition:</b> #{land_bank['property_condition']}"
      else
        land_bank['disclosure_attributes'] = [
          "<b>Property Class:</b> #{land_bank['property_class']}",
          "<b>Potential Use:</b> #{land_bank['potential_use']}",
          "<b>Property Condition:</b> #{land_bank['property_condition']}"
        ]
      end
    }
  end
end