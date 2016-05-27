class NeighborhoodServices::VacancyData::Filters::Foreclosure
  def initialize(land_bank_data)
    @land_bank_data = land_bank_data.dup
  end

  def filtered_data
    @land_bank_data.select { |land_bank|
      land_bank['foreclosure_year'].present?
    }.each { |land_bank|
      land_bank['disclosure_attributes'] = ["<b>Foreclosure Year:</b> #{land_bank['foreclosure_year']}"]
    }
  end
end