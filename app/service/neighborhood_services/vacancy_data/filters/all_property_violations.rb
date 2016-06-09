class NeighborhoodServices::VacancyData::Filters::AllPropertyViolations
  def initialize(property_violations_data)
    @property_violations_data = property_violations_data.dup
  end

  def filtered_data
    @property_violations_data.select { |property_violation|
      property_violation['status'] == 'Open'
    }.each { |property_violation|
      property_violation['disclosure_attributes'] = [property_violation['violation_description']]
    }
  end
end
