class NeighborhoodServices::VacancyData::Filters::DemoNeeded
  def initialize(landbank_data)
    @landbank_data = landbank_data
  end

  def filtered_data
    @landbank_data.select { |land_bank|
      land_bank['demo_needed'] == 'Y'
    }.each { |land_bank|
      if land_bank['disclosure_attributes']
        land_bank['disclosure_attributes'] << 'Demo Needed'
      else
        land_bank['disclosure_attributes'] = ['Demo Needed']
      end
    }
  end
end