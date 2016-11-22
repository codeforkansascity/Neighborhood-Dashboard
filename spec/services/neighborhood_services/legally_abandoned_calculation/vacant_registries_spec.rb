require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::VacantRegistries do
  let(:neighborhood) { double(name: 'Neighborhood 1', address_source_uri: 'http://data.hax') }
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::VacantRegistries.new(neighborhood) }
  let(:vacant_lot_data) {
    [
      {
        'property_address' => 'Test address 1',
        'longitude' => 90.0,
        'latitude' => 45.0,
        'registration_type' => 'Registered',
        'neighborhood' => 'Neighborhood 1',
        'last_verified' => 'Yesterday'
      },
      {
        'property_address' => 'Test address 2',
        'longitude' => 90.0,
        'latitude' => 45.0,
        'registration_type' => 'Registered',
        'neighborhood' => 'Neighborhood 1',
        'last_verified' => 'Yesterday'
      },
      {
        'property_address' => 'Test address 3',
        'longitude' => 90.0,
        'latitude' => 45.0,
        'registration_type' => 'Registered',
        'neighborhood' => 'Neighborhood 2',
        'last_verified' => 'Yesterday'
      },
      {
        'property_address' => 'Test address 4',
        'longitude' => 90.0,
        'latitude' => 45.0,
        'registration_type' => 'Registered',
        'neighborhood' => 'Neighborhood 4',
        'last_verified' => 'Yesterday'
      },
      {
        'property_address' => 'Test address 5',
        'longitude' => 90.0,
        'latitude' => 45.0,
        'registration_type' => 'Registered',
        'neighborhood' => 'Neighborhood 6',
        'last_verified' => 'Yesterday'
      },
      {
        'property_address' => 'Test address 6',
        'longitude' => 90.0,
        'latitude' => 45.0,
        'registration_type' => 'Registered',
        'neighborhood' => 'Neighborhood 1',
        'last_verified' => 'Yesterday'
      }
    ]
  }

  before do
    allow(StaticData).to receive(:VACANT_LOT_DATA).and_return(vacant_lot_data)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }

    it 'includes all the parcels associated to the neighborhood with the key being the address lowercased' do
      expect(calculated_data['test address 1']).to_not be_nil
      expect(calculated_data['test address 2']).to_not be_nil
      expect(calculated_data['test address 6']).to_not be_nil
    end

    it 'excludes all the parcels not associated to the neighborhood' do
      expect(calculated_data['test address 3']).to be_nil
      expect(calculated_data['test address 4']).to be_nil
      expect(calculated_data['test address 5']).to be_nil
    end

    it 'includes a value of 2 points for each individual address' do
      expect(calculated_data['test address 1'][:points]).to eq(2)
      expect(calculated_data['test address 2'][:points]).to eq(2)
      expect(calculated_data['test address 6'][:points]).to eq(2)
    end

    it 'includes the longitude for each individual address' do
      expect(calculated_data['test address 1'][:longitude]).to eq(90.0)
      expect(calculated_data['test address 2'][:longitude]).to eq(90.0)
      expect(calculated_data['test address 6'][:longitude]).to eq(90.0)
    end

    it 'includes the latitude for each individual address' do
      expect(calculated_data['test address 1'][:latitude]).to eq(45.0)
      expect(calculated_data['test address 2'][:latitude]).to eq(45.0)
      expect(calculated_data['test address 6'][:latitude]).to eq(45.0)
    end

    it 'adds the registration type as one of the disclosure_attributes' do
      expect(calculated_data['test address 1'][:disclosure_attributes][1]).to eq(
        '<b>Registration Type:</b> Registered<br/><b>Last Verified:</b> Yesterday'
      )

      expect(calculated_data['test address 2'][:disclosure_attributes][1]).to eq(
        '<b>Registration Type:</b> Registered<br/><b>Last Verified:</b> Yesterday'
      )

      expect(calculated_data['test address 6'][:disclosure_attributes][1]).to eq(
        '<b>Registration Type:</b> Registered<br/><b>Last Verified:</b> Yesterday'
      )
    end
  end
end
