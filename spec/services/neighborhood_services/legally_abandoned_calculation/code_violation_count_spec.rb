require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount do
  let(:neighborhood) { double(name: 'Neighborhood 1', address_source_uri: 'http://data.hax') }
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount.new(neighborhood) }
  let(:violation_query_object) { double }
  let(:code_violation_data) do
    [
      {
        'address' => 'Address 1',
        'days_open' => 1100,
        'violation_description' => 'Description',
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      },
      {
        'address' => 'Address 2',
        'days_open' => 1000,
        'violation_description' => 'Description',
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      },
      {
        'address' => 'Address 3',
        'days_open' => 240,
        'violation_description' => 'Description',
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      },
      {
        'address' => 'Address 4',
        'days_open' => 240,
        'violation_description' => 'Description',
        'mapping_location' => {
          'coordinates' => [-45, 100]
        }
      }
    ]
  end

  before do
    allow(KcmoDatasets::PropertyViolations).to receive(:new).and_return(violation_query_object)
    allow(violation_query_object).to receive(:open_cases).and_return(violation_query_object)
    allow(violation_query_object).to receive(:request_data ).and_return(code_violation_data)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }

    context 'when an address has had a code violation that is older than 3 years' do
      it 'has a value of 2 points for that address' do
        expect(calculated_data['address 1'][:points]).to eq(2)
      end

      it 'adds the longitude and latitude to the data' do
        expect(calculated_data['address 1'][:longitude]).to eq(-45)
        expect(calculated_data['address 1'][:latitude]).to eq(100)
      end

      it 'adds a message detailing the violation count' do
        expect(calculated_data['address 1'][:disclosure_attributes][1]).to eq(
          'Description: 3 Years open'
        )
      end
    end

    context 'when an address has had a violation that is between 1 and 3 years old' do
      it 'has a value of 2 points for that address' do
        expect(calculated_data['address 2'][:points]).to eq(1)
      end

      it 'adds the longitude and latitude to the data' do
        expect(calculated_data['address 2'][:longitude]).to eq(-45)
        expect(calculated_data['address 2'][:latitude]).to eq(100)
      end

      it 'adds a message detailing the violation count' do
        expect(calculated_data['address 2'][:disclosure_attributes][1]).to eq(
          'Description: 2 Years open'
        )
      end
    end

    context 'when an address has a violation that is less than a year old' do
      it 'does not include the violation in the dataset' do
        expect(calculated_data['address 3']).to be_nil
      end
    end
  end
end
