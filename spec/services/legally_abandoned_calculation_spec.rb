require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation do
  let(:neighborhood) { double(name: 'Neighborhood')}
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation.new(neighborhood) }

  let(:vacant_registry_failures) { double }
  let(:tax_delinquent_datasets) { double }
  let(:code_violation_count) { double }
  let(:three_eleven_data) { double }
  let(:vacant_registries) { double }
  let(:dangerous_buildings) { double }

  let(:mock_addresses) do
    {
      'address 1' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 1'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 2' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 2'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 3' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 3'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 4' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 4'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 5' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 5'],
        categories: []
      },
      'address 6' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 6'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 7' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 7'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 8' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 8'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 9' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 9'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      }
    }
  end

  let(:multiple_disclosure) do
    {
      'address 4' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 4 Additional'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      },
      'address 6' => {
        points: 2,
        longitude: -45,
        latitude: 90,
        disclosure_attributes: ['String 6 Additional'],
        categories: [
          NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION,
          NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION
        ]
      }
    }
  end

  let(:mock_parcel_data) do
    [ 
      {
        "properties" => {
          "land_ban60" => "address 1\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 2\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 3\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 4\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 5\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 6\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 7\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      },
      {
        "properties" => {
          "land_ban60" => "address 8\nkansas city"
        },
        "geometry" => {
          "coordinates" => [[-45, 100],[-50, 100],[-50, 0]]
        }
      }
    ]
  end

  before do
    allow(NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData).to receive(:new).and_return(three_eleven_data)
    allow(three_eleven_data).to receive(:calculated_data).and_return(
      {
        'address 1' => mock_addresses['address 1'], 
        'address 2' => mock_addresses['address 2'], 
        'address 3' => mock_addresses['address 3'],
        'address 4' => mock_addresses['address 4']
      }
    )

    allow(NeighborhoodServices::LegallyAbandonedCalculation::VacantRegistries).to receive(:new).and_return(vacant_registries)
    allow(vacant_registries).to receive(:calculated_data).and_return(
      {'address 1' => mock_addresses['address 1'], 'address 2' => mock_addresses['address 2'], 'address 3' => mock_addresses['address 3']}
    )

    allow(NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings).to receive(:new).and_return(dangerous_buildings)
    allow(dangerous_buildings).to receive(:calculated_data).and_return(
      {'address 1' => mock_addresses['address 1'], 'address 2' => mock_addresses['address 2'], 'address 3' => mock_addresses['address 3']}
    )

    allow(NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations).to receive(:new).and_return(vacant_registry_failures)
    
    allow(vacant_registry_failures).to receive(:calculated_data).and_return(
      {'address 1' => mock_addresses['address 1'], 'address 2' => mock_addresses['address 2'], 'address 3' => mock_addresses['address 3']}
    )

    allow(NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent).to receive(:new).and_return(tax_delinquent_datasets)
    allow(tax_delinquent_datasets).to receive(:calculated_data).and_return(
      {'address 4' => mock_addresses['address 4'], 'address 5' => mock_addresses['address 5'], 'address 6' => mock_addresses['address 6']}
    )

    allow(NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount).to receive(:new).and_return(code_violation_count)
    allow(code_violation_count).to receive(:calculated_data).and_return(
      {
        'address 4' => multiple_disclosure['address 4'], 
        'address 5' => mock_addresses['address 5'], 
        'address 6' => multiple_disclosure['address 6'], 
        'address 7' => mock_addresses['address 7'], 
        'address 8' => mock_addresses['address 8'], 
        'address 9' => mock_addresses['address 9']
      }
    )

    allow(StaticData).to receive(:PARCEL_DATA).and_return(mock_parcel_data)
  end

  describe '#vacant_indicators' do
    let(:vacant_indicators) { dataset.vacant_indicators }

    it 'only scores the three_eleven, vacant_registries, dangerous_buildings, and vacant_registry_failures with a max total of 2 points' do
      test_address = vacant_indicators.select{ |address| address['properties']['address'] == 'address 1' }
      expect(test_address.first['properties']['points']).to eq(2)
    end

    it 'only contains datapoints that belong to each scoring category' do
      addresses = vacant_indicators.map{|hash| hash['properties']['address']}

      expect(addresses).to include('address 1', 'address 4', 'address 6', 'address 9')
      expect(addresses).to_not include('address 2', 'address 3', 'address 5', 'address 7', 'address 8')
    end

    it 'adds up all the points for a given address' do
      test_address_one = vacant_indicators.select{ |address| address['properties']['address'] == 'address 4' }
      expect(test_address_one.first['properties']['points']).to eq(6)

      test_address_two = vacant_indicators.select{ |address| address['properties']['address'] == 'address 6' }
      expect(test_address_two.first['properties']['points']).to eq(4)

      test_address_three = vacant_indicators.select{ |address| address['properties']['address'] == 'address 1' }
      expect(test_address_three.first['properties']['points']).to eq(2)
    end

    it 'combines all the disclosure attributes for a given address and strips out any duplicates' do
      test_address_one = vacant_indicators.select{ |address| address['properties']['address'] == 'address 4' }
      expect(test_address_one.first['properties']['disclosure_attributes']).to eq(
        ['String 4', 'String 4 Additional']
      )

      test_address_two = vacant_indicators.select{ |address| address['properties']['address'] == 'address 6' }
      expect(test_address_two.first['properties']['disclosure_attributes']).to eq(
        ['String 6', 'String 6 Additional']
      )
    end

    it 'gives the appropriate fill color for the appropriate point value for each address' do
      test_address_one = vacant_indicators.select{ |address| address['properties']['address'] == 'address 4' }
      expect(test_address_one.first['properties']['color']).to eq('#000')

      test_address_two = vacant_indicators.select{ |address| address['properties']['address'] == 'address 6' }
      expect(test_address_two.first['properties']['color']).to eq('#444')

      test_address_three = vacant_indicators.select{ |address| address['properties']['address'] == 'address 1' }
      expect(test_address_three.first['properties']['color']).to eq('#888')
    end

    it 'converts any parcels without geometric coordinates to a point' do
      target_address = vacant_indicators.select{ |address| address['properties']['address'] == 'address 9' }.first
      expect(target_address['geometry']['type']).to eq('Point')
    end

    it 'adds the property marker_style with the value "Circle" to the properties object' do
      target_address = vacant_indicators.select{ |address| address['properties']['address'] == 'address 9' }.first
      expect(target_address['properties']['marker_style']).to eq('Circle')
    end
  end
end
