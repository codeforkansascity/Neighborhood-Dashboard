require 'rails_helper'

RSpec.describe NeighborhoodServices::VacancyData::LandBank, :type => :controller do
  let(:neighborhood) { double(name: 'Testing Neighborhood')}
  let(:mock_landbank_client) { double }
  let(:vacant_filters) { {} }

  let(:parcel_old) {
    {
      'parcel_number' => 'parcel-1',
      'location_1'=> {
        'coordinates' => [49.2912, -39.12312]
      },
      'location_1_address' => "0 NO ADDRESS",
      'acquisition_date' => 'May 15, 2012'
    }
  }

  let(:parcel_mid_aged) {
    {
      'parcel_number' => 'parcel-2',
      'location_1'=> {
        'coordinates' => [49.2912, -39.12312]
      },
      'location_1_address' => "0 NO ADDRESS",
      'acquisition_date' => 'May 15, 2014'
    }
  }

  let(:parcel_new) {
    {
      'parcel_number' => 'parcel-3',
      'location_1'=> {
        'coordinates' => [49.2912, -39.12312]
      },
      'location_1_address' => "0 NO ADDRESS",
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
          'coordinates' => []
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

  let(:metadata) { {'viewLastModified' => 1433307658} }

  before do
    allow(StaticData).to receive(:PARCEL_DATA).and_return(parcel_geometric_data)
    allow(Date).to receive('today').and_return(Date.new(2016, 05, 15))
    
    allow(KcmoDatasets::LandBankData).to receive(:new)
      .with(neighborhood)
      .and_return(mock_landbank_client)

    allow(mock_landbank_client).to receive(:filters=)
    allow(mock_landbank_client).to receive(:request_data).and_return(parcel_responses)
    allow(mock_landbank_client).to receive(:metadata).and_return(metadata)

    allow(HTTParty).to receive(:get).with('https://data.kcmo.org/api/views/2ebw-sp7f/').and_return(double(response: double(body: metadata)))
  end

  subject { NeighborhoodServices::VacancyData::LandBank.new(neighborhood, vacant_filters) }

  describe '#data' do
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
          type: 'Feature',
          geometry: {
            "type"=>"Polygon",
            "coordinates"=>[[0, 0], [1, 1], [2, 2], [3, 3], [4, 4]]
          },
          properties: {
            "parcel_number"=>"parcel-1",
            "color"=>"#000000",
            disclosure_attributes: [
              "<h3 class='info-window-header'>Land Bank Data:</h3>&nbsp;<a href='#{KcmoDatasets::LandBankData::SOURCE_URI}'>Source</a>",
              "Last Updated Date: 06/03/2015",
              "<b>Address:</b>&nbsp;0 No Address",
              "<b>Foreclosure Year:</b> "
            ]
          }
        }
      }

      let(:vacant_filters) { {filters: ['foreclosed']} }

      before do
        allow(NeighborhoodServices::VacancyData::Filters::Foreclosure)
          .to receive(:new)
          .and_return(double(filtered_data: filtered_foreclosure_data))
      end

      it 'returns a hash of all the parcels that also contain geometric parcel data' do
        expect(subject.data.find{ |parcel| parcel.parcel_number == 'parcel-1'}.to_h)
          .to eq(expected_foreclosed_filter_response_hash)
      end

      it 'excludes any parcels that do not have any geometric coordinates' do
        expect(subject.data.find{ |parcel| parcel.parcel_number == 'parcel-4'})
          .to be_nil
      end

      it 'assigns #000000 for parcels that are older than 3 years' do
        target_parcel = subject.data.find { |parcel| parcel.parcel_number == 'parcel-1' }
        expect(target_parcel.properties['color']).to eq('#000000')
      end

      it 'assigns #3A46B2 for parcels between 1 and 3 years in age' do
        target_parcel = subject.data.find { |parcel| parcel.parcel_number == 'parcel-2' }
        expect(target_parcel.properties['color']).to eq('#3A46B2')
      end

      it 'assigns #A3F5FF for parcels less than a year in age' do
        target_parcel = subject.data.find { |parcel| parcel.parcel_number == 'parcel-3' }
        expect(target_parcel.properties['color']).to eq('#A3F5FF')
      end
    end
  end
end
