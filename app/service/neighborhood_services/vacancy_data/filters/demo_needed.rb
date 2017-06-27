class NeighborhoodServices::VacancyData::Filters::DemoNeeded
  def initialize(land_bank_data)
    @land_bank_data = land_bank_data.clone
  end

  def filtered_data
    @land_bank_data.select { |land_bank|
      land_bank['demo_needed'] == 'Y'
    }
  end
end
