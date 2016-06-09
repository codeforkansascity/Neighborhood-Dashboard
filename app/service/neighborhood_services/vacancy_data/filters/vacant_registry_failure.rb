class NeighborhoodServices::VacancyData::Filters::VacantRegistryFailure
  def initialize(three_eleven_data)
    @three_eleven_data = three_eleven_data.dup
  end

  def filtered_data
    @three_eleven_data
      .select { |three_eleven_violation|
        three_eleven_violation['violation_code'] == 'NSVACANT'
      }
      .each { |three_eleven_violation|
        three_eleven_violation['disclosure_attributes'] = [
          "Failure to Register as Vacant"
        ]
      }
  end
end
