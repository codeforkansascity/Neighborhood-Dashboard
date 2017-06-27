class NeighborhoodServices::VacancyData::Filters::Foreclosure
  def initialize(land_bank_data)
    @land_bank_data = land_bank_data.clone
  end

  def filtered_data
    @land_bank_data.select { |land_bank|
      land_bank['foreclosure_year'].present?
    }
  end
end
