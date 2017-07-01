require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount do
  let(:neighborhood) { double(name: 'Neighborhood 1') }
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount.new(neighborhood) }
  let(:violation_query_object) { double }
  let(:code_violation_data) do
    [
      {
        'address' => 'Address 1',
        'count_address' => 9,
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      }
    ]
  end

  before do
    allow(KcmoDatasets::PropertyViolations).to receive(:grouped_address_counts).and_return(code_violation_data)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }

    it 'attaches the code violation count to the hash' do
      expect(calculated_data['address 1'][:violation_count]).to eq(9)
    end

    it 'adds the longitude and latitude to the data' do
      expect(calculated_data['address 1'][:longitude]).to eq(-45)
      expect(calculated_data['address 1'][:latitude]).to eq(100)
    end
  end
end