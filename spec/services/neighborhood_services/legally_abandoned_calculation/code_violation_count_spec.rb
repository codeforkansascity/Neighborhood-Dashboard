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
      },
      {
        'address' => 'Address 2',
        'count_address' => 3,
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      },
      {
        'address' => 'Address 3',
        'count_address' => 2,
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      },
      {
        'address' => 'Address 4',
        'count_address' => 1,
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

    context 'when an address has greater than 3 violations' do
      it 'has a value of 2 points for that address' do
        expect(calculated_data['address 1'][:points]).to eq(2)
      end

      it 'adds the longitude and latitude to the data' do
        expect(calculated_data['address 1'][:longitude]).to eq(-45)
        expect(calculated_data['address 1'][:latitude]).to eq(100)
      end

      it 'adds a message detailing the violation count' do
        expect(calculated_data['address 1'][:disclosure_attributes]).to eq(['9 Property Violations'])
      end
    end

    context 'when an address has 3 violations' do
      it 'has a value of 2 points for that address' do
        expect(calculated_data['address 2'][:points]).to eq(2)
      end

      it 'adds the longitude and latitude to the data' do
        expect(calculated_data['address 2'][:longitude]).to eq(-45)
        expect(calculated_data['address 2'][:latitude]).to eq(100)
      end

      it 'adds a message detailing the violation count' do
        expect(calculated_data['address 2'][:disclosure_attributes]).to eq(['3 Property Violations'])
      end
    end

    context 'when an address has 2 violations' do
      it 'has a value of 2 points for that address' do
        expect(calculated_data['address 3'][:points]).to eq(1)
      end

      it 'adds the longitude and latitude to the data' do
        expect(calculated_data['address 3'][:longitude]).to eq(-45)
        expect(calculated_data['address 3'][:latitude]).to eq(100)
      end

      it 'adds a message detailing the violation count' do
        expect(calculated_data['address 3'][:disclosure_attributes]).to eq(['2 Property Violations'])
      end
    end

    context 'when an address has less than 2 violations' do
      it 'does not add the address to the returned hash' do
        expect(calculated_data['address 4']).to be_nil
      end
    end
  end
end