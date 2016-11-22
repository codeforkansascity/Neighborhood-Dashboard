require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData do
  let(:neighborhood) { double(name: 'Neighborhood', address_source_uri: 'http://data.hax')}
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData.new(neighborhood) }
  let(:three_eleven_client_query) { double }
  let(:three_eleven_data) {
    [
      {
        'street_address' => 'Street Address 1',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      },
      {
        'street_address' => 'Street Address 1',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      },
      {
        'street_address' => 'Street Address 2',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      },
      {
        'street_address' => 'Street Address 3',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      },
      {
        'street_address' => 'Street Address 4',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      },
      {
        'street_address' => 'Street Address 4',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      },
      {
        'street_address' => 'Street Address 4',
        'request_type' => 'verified',
        'address_with_geocode' => {
          'coordinates' => [34.2342, 24.2343]
        }
      }
    ]
  }

  before do
    allow(KcmoDatasets::ThreeElevenCases).to receive(:new).and_return(three_eleven_client_query)
    allow(three_eleven_client_query).to receive(:open_cases).and_return(three_eleven_client_query)
    allow(three_eleven_client_query).to receive(:vacant_called_in_violations).and_return(three_eleven_client_query)
    allow(three_eleven_client_query).to receive(:request_data).and_return(three_eleven_data)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }

    it 'creates a hash with the key as the lowercased address and a point for every violation' do
      expect(calculated_data['street address 1'])
    end
  end
end