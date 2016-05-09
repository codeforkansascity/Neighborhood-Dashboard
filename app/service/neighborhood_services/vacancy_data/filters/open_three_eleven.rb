class NeighborhoodServices::VacancyData::Filters::OpenThreeEleven
  def initialize(three_eleven_data)
    @three_eleven_data = three_eleven_data.dup
  end

  def filtered_data
    @three_eleven_data
      .select { |three_eleven_violation|
        three_eleven_violation['status'] == 'OPEN'
      }
      .each { |three_eleven_violation|
        three_eleven_violation['disclosure_attributes'] = [
          'Open'
        ]
      }
  end
end
