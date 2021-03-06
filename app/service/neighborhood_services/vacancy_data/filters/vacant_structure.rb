class NeighborhoodServices::VacancyData::Filters::VacantStructure
  def initialize(three_eleven_data)
    @three_eleven_data = three_eleven_data.dup
  end

  def filtered_data
    @three_eleven_data
      .select { |three_eleven_violation|
        three_eleven_violation['request_type'] == 'Nuisance Violations on Private Property Vacant Structure' ||
        three_eleven_violation['request_type'] == 'Vacant Structure Open to Entry' ||
        three_eleven_violation['request_type'] == 'Animal Control'
      }
  end
end
