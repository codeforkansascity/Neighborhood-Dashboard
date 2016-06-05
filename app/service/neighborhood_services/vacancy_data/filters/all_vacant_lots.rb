class NeighborhoodServices::VacancyData::Filters::AllVacantLots
  def initialize(land_bank_data)
    @land_bank_data = land_bank_data.clone
  end

  def filtered_data
    @land_bank_data.each { |land_bank|
      current_disclosure_attributes = land_bank['disclosure_attributes'] || []
      land_bank['disclosure_attributes'] = current_disclosure_attributes + [
        "<b>Property Class:</b> #{land_bank['property_class']}",
        "<b>Potential Use:</b> #{land_bank['potential_use']}",
        "<b>Property Condition:</b> #{land_bank['property_condition']}"
      ]
    }
  end
end
