require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings do
  let(:neighborhood) { double(name: 'Neighborhood', address_source_uri: 'http://data.hax') }
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings.new(neighborhood) }
  let(:dangerous_building_data_query) { double }
  let(:dangerous_building_data) do
    [
      {
        'address' => 'Address 1',
        'location' => {
          'coordinates' => [-50, 100]
        },
        'statusofcase' => 'statusofcase'
      },
      {
        'location' => {
          'coordinates' => [-50, 100]
        },
        'statusofcase' => 'statusofcase'
      },
      {
        'address' => '',
        'location' => {
          'coordinates' => [-50, 100]
        },
        'statusofcase' => 'statusofcase'
      }
    ]
  end

  let(:metadata) { {'viewLastModified' => 1433307658} }

  before do
    allow(KcmoDatasets::DangerousBuildings).to receive(:new).and_return(dangerous_building_data_query)
    allow(dangerous_building_data_query).to receive(:request_data).and_return(dangerous_building_data)
    allow(dangerous_building_data_query).to receive(:metadata).and_return(metadata)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }

    it 'only adds in data that contains an address' do
      expect(calculated_data.length).to eq(1)
      expect(calculated_data['address 1']).to_not be_nil
    end

    it 'adds status of the case to the hash' do
      expect(calculated_data['address 1'][:statusofcase]).to eq('statusofcase')
    end

    it 'sets the latitude and longitude appropriately for the addresses' do
      expect(calculated_data['address 1'][:longitude]).to eq(-50)
      expect(calculated_data['address 1'][:latitude]).to eq(100)
    end
  end
end
