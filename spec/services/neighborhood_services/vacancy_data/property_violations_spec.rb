require 'rails_helper'

RSpec.describe NeighborhoodServices::VacancyData::PropertyViolations do
  subject { NeighborhoodServices::VacancyData::PropertyViolations.new(neighborhood, filters) }
  
  let(:neighborhood) { double(id: 1, name: 'Test')}  
  let(:filters) { {} }

  before do
    allow()
  end

  describe '#data' do
    context 'when no filters for vacant data are present' do
    end
  end 
end
