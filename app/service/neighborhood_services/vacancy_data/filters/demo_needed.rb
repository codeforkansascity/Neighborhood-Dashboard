class NeighborhoodServices::VacancyData::Filters::DemoNeeded
  def initialize(land_bank_data)
    @land_bank_data = land_bank_data.clone
  end

  def filtered_data
    @land_bank_data.select { |land_bank|
      land_bank['demo_needed'] == 'Y'
    }.each { |land_bank|
      current_disclosure_attributes = land_bank['disclosure_attributes'] || []
      land_bank['disclosure_attributes'] = current_disclosure_attributes + ['Demo Needed']
    }
  end
end
