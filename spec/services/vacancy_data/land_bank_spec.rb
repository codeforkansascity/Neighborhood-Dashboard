require 'rails_helper'

RSpec.describe NeighborhoodServices::VacancyData::LandBank, :type => :controller do
  let(:neighborhood) { double(name: 'Testing Neighborhood')}
  let(:vacant_filters) { {} }

  let(:parcel_old) {
    {
      'parcel_number' => 'parcel-1',
      'location_1'=> {
        'latitude' => -39.12312,
        'longitude' => 49.2912
      },
      'acquisition_date' => 'May 15, 2012'
    }
  }

  let(:parcel_mid_aged) {
    {
      'parcel_number' => 'parcel-2',
      'location_1'=> {
        'latitude' => -39.12312,
        'longitude' => 49.2912
      },
      'acquisition_date' => 'May 15, 2014'
    }
  }

  let(:parcel_new) {
    {
      'parcel_number' => 'parcel-3',
      'location_1'=> {
        'latitude' => -39.12312,
        'longitude' => 49.2912
      },
      'acquisition_date' => 'January 15, 2016'
    }
  }

  let(:parcel_no_geometric_coordinates) {
    {
      'parcel_number' => 'parcel-4',
      'acquisition_date' => 'January 15, 2016'
    }
  }

  let(:parcel_geometric_data) {
    [
      {
        'properties' => {
          'apn' => 'parcel-1'
        },
        'geometry' => {
          'coordinates' => [[[0,0], [1,1], [2,2], [3,3], [4,4]]]
        }
      },
      {
        'properties' => {
          'apn' => 'parcel-2'
        },
        'geometry' => {
          'coordinates' => [[[0,0], [1,1], [2,2], [3,3], [4,4]]]
        }
      },
      {
        'properties' => {
          'apn' => 'parcel-3'
        },
        'geometry' => {
          'coordinates' => [[[0,0], [1,1], [2,2], [3,3], [4,4]]]
        }
      },
      {
        'properties' => {
          'apn' => 'parcel-4'
        },
        'geometry' => {
          'coordinates' => [[[0,0], [1,1], [2,2], [3,3], [4,4]]]
        }
      },
      {
        'properties' => {
          'apn' => 'parcel-5'
        },
        'geometry' => {
          'coordinates' => [[[0,0], [1,1], [2,2], [3,3], [4,4]]]
        }
      },
    ]
  }

  let(:parcel_responses) {
    [parcel_old, parcel_mid_aged, parcel_new, parcel_no_geometric_coordinates]
  }

  let(:mocked_endpoint) { 'https://servercall.com' }

  before do
    allow(StaticData).to receive(:PARCEL_DATA).and_return(parcel_geometric_data)

    allow(Date).to receive('today').and_return(Date.new(2016, 05, 15))

    allow(URI).to receive(:escape).and_return(mocked_endpoint)
    allow(HTTParty).to receive(:get).with(mocked_endpoint, verify: false).and_return(parcel_responses)
  end

  subject { NeighborhoodServices::VacancyData::LandBank.new(neighborhood, vacant_filters) }

  describe '#data' do
    context 'when no filters are passed into the dataset' do
      it 'returns an empty hash' do
        expect(subject.data).to eq([])
      end
    end

    context 'when foreclosed vacant code is passed into the data service' do
      let(:filtered_foreclosure_data) {
        [
          parcel_old.merge({'disclosure_attributes' => ['<p>Foreclosure Year</p>']}),
          parcel_mid_aged.merge({'disclosure_attributes' => ['<p>Foreclosure Year</p>']}),
          parcel_new.merge({'disclosure_attributes' => ['<p>Foreclosure Year</p>']}),
          parcel_no_geometric_coordinates.merge({'disclosure_attributes' => ['<p>Foreclosure Year</p>']})
        ]
      }

      let(:expected_foreclosed_filter_response_hash) {
        {
          "type"=>"Feature", 
          "geometry"=> {
            "type"=>"Polygon", 
            "coordinates"=>[[0, 0], [1, 1], [2, 2], [3, 3], [4, 4]]
          }, 
          "properties"=> {
            "parcel_number"=>"parcel-1", 
            "color"=>"#000000", 
            "disclosure_attributes" => [
              "<b>Property Class:</b> ", 
              "<b>Potential Use:</b> ", 
              "<b>Property Condition:</b> ", 
              "<p>Foreclosure Year</p>"
            ]
          }
        }
      }

      let(:vacant_filters) { {vacant_codes: ['foreclosed']} }

      before do
        allow(NeighborhoodServices::VacancyData::Filters::Foreclosure)
          .to receive(:new)
          .and_return(double(filtered_data: filtered_foreclosure_data))
      end

      it 'returns a hash of all the parcels that also contain geometric parcel data' do
        expect(subject.data.find{ |parcel| parcel['properties']['parcel_number'] == 'parcel-1'})
          .to eq(expected_foreclosed_filter_response_hash)
      end

      it 'excludes any parcels that do not have any geometric coordinates' do
        expect(subject.data.find{ |parcel| parcel['properties']['parcel_number'] == 'parcel-4'})
          .to be_nil
      end

      it 'assigns #000000 for parcels that are older than 3 years' do
        target_parcel = subject.data.find { |parcel| parcel['properties']['parcel_number'] == 'parcel-1' }
        expect(target_parcel['properties']['color']).to eq('#000000')
      end

      it 'assigns #3A46B2 for parcels between 1 and 3 years in age' do
        target_parcel = subject.data.find { |parcel| parcel['properties']['parcel_number'] == 'parcel-2' }
        expect(target_parcel['properties']['color']).to eq('#3A46B2')
      end

      it 'assigns #A3F5FF for parcels less than a year in age' do
        target_parcel = subject.data.find { |parcel| parcel['properties']['parcel_number'] == 'parcel-3' }
        expect(target_parcel['properties']['color']).to eq('#A3F5FF')
      end
    end
  end
end
