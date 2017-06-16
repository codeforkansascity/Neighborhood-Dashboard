require 'rails_helper'

RSpec.describe NeighborhoodServices::Crime do
  let(:neighborhood) { double(id: 2, name: 'Neighborhood 1') }
  let(:options) { {} }
  let(:mock_kcmo_crime) { double() }

  let(:valid_coordinates_person) {
    {
      "location_1" => {
        "coordinates" => [-39, 39]
      },
      "ibrs" => '13A',
      "disclosure_attributes" => ['<p>Example disclosure</p>'],
      "from_date" => '2016-03-18T00:00:00.000',
      "address" => '1519 Main St',
      "source" => 'www.data_person.org',
      "last_updated" => '2016-05-23T00:00:00.000'
    }
  }

  let(:valid_coordinates_property) {
    {
      "location_1" => {
        "coordinates" => [-39, 39]
      },
      "ibrs" => '200',
      "disclosure_attributes" => ['<p>Example disclosure</p>'],
      "from_date" => '2016-03-18T00:00:00.000',
      "address" => '1519 Main St',
      "source" => 'www.data_property.org',
      "last_updated" => '2016-05-23T00:00:00.000'
    }
  }

  let(:valid_coordinates_society) {
    {
      "location_1" => {
        "coordinates" => [-39, 39]
      },
      "ibrs" => '35A',
      "description" => 'Fake Crime',
      "disclosure_attributes" => ['<p>Example disclosure</p>'],
      "from_date" => '2016-03-18T00:00:00.000',
      "address" => '1519 Main St',
      "source" => 'www.data_society.org',
      "last_updated" => '2016-05-23T00:00:00.000'
    }
  }

  before do
    allow(Neighborhood).to receive(:find).with(neighborhood.id).and_return(neighborhood)
    allow(KcmoDatasets::Crime).to receive(:new).with(neighborhood, options).and_return(mock_kcmo_crime)
  end

  describe '#grouped_totals' do
    let(:mock_grouped_totals) { {total: 14} }

    before do
      allow(mock_kcmo_crime).to receive(:grouped_totals).and_return(mock_grouped_totals)
      allow(CrimeMapper).to receive(:convert_crime_key_to_application_key)
        .with(mock_grouped_totals)
        .and_return(mock_grouped_totals)
    end

    it 'retrieves the grouped_totals_data' do
      expect(NeighborhoodServices::Crime.new(neighborhood.id, options).grouped_totals)
        .to eq(mock_grouped_totals)
    end
  end

  describe '#mapped_coordinates' do
    context 'when a valid crime against a person is retrieved' do
      let(:data) { NeighborhoodServices::Crime.new(neighborhood.id, options).mapped_coordinates }

      before do
        allow(mock_kcmo_crime).to receive(:query_data)
          .and_return([valid_coordinates_person])
      end

      it 'attaches the correct ibrs to the coordinates' do
        expect(data.first['ibrs']).to eq(valid_coordinates_person['ibrs'])
      end

      it 'sets the type appropriately to "feature"' do
        expect(data.first['type']).to eq('Feature')
      end 

      it 'sets the geometry coordinates appropriately' do
        expect(data.first['geometry']['type']).to eq('Point')
        expect(data.first['geometry']['coordinates']).to eq(valid_coordinates_person['location_1']['coordinates'])
      end

      it 'attaches the description to the disclosure attributes' do
        expect(data.first['properties']['disclosure_attributes'][0]).to eq(valid_coordinates_person['description'])
      end

      it 'returns the coordinates with the correct address' do
        expect(data.first['properties']['disclosure_attributes'][1]).to eq(valid_coordinates_person['address'].titleize)
      end

      it 'parses the date correct for the from date' do
        expect(data.first['properties']['disclosure_attributes'][2]).to eq('Committed on 03/18/2016')
      end

      it 'displays the correct link for the source' do
        expect(data.first['properties']['disclosure_attributes'][3]).to eq("<a href=www.data_person.org>Data Source</a>")
      end

      it 'returns the correct color for the marker' do
        expect(data.first['properties']['color']).to eq('#626AB2')
      end
    end

    context 'when a valid crime against a property is retrieved' do
      let(:data) { NeighborhoodServices::Crime.new(neighborhood.id, options).mapped_coordinates }

      before do
        allow(mock_kcmo_crime).to receive(:query_data)
          .and_return([valid_coordinates_property])
      end

      it 'attaches the correct ibrs to the coordinates' do
        expect(data.first['ibrs']).to eq(valid_coordinates_property['ibrs'])
      end

      it 'sets the type appropriately to "feature"' do
        expect(data.first['type']).to eq('Feature')
      end 

      it 'sets the geometry coordinates appropriately' do
        expect(data.first['geometry']['type']).to eq('Point')
        expect(data.first['geometry']['coordinates']).to eq(valid_coordinates_property['location_1']['coordinates'])
      end

      it 'attaches the description to the disclosure attributes' do
        expect(data.first['properties']['disclosure_attributes'][0]).to eq(valid_coordinates_property['description'])
      end

      it 'returns the coordinates with the correct address' do
        expect(data.first['properties']['disclosure_attributes'][1]).to eq(valid_coordinates_property['address'].titleize)
      end

      it 'parses the date correct for the from date' do
        expect(data.first['properties']['disclosure_attributes'][2]).to eq('Committed on 03/18/2016')
      end

      it 'displays the correct link for the source' do
        expect(data.first['properties']['disclosure_attributes'][3]).to eq("<a href=www.data_property.org>Data Source</a>")
      end

      it 'returns the correct color for the marker' do
        expect(data.first['properties']['color']).to eq('#313945')
      end
    end

    context 'when a valid crime against a property is retrieved' do
      let(:data) { NeighborhoodServices::Crime.new(neighborhood.id, options).mapped_coordinates }

      before do
        allow(mock_kcmo_crime).to receive(:query_data)
          .and_return([valid_coordinates_society])
      end

      it 'attaches the correct ibrs to the coordinates' do
        expect(data.first['ibrs']).to eq(valid_coordinates_society['ibrs'])
      end

      it 'sets the type appropriately to "feature"' do
        expect(data.first['type']).to eq('Feature')
      end 

      it 'sets the geometry coordinates appropriately' do
        expect(data.first['geometry']['type']).to eq('Point')
        expect(data.first['geometry']['coordinates']).to eq(valid_coordinates_society['location_1']['coordinates'])
      end

      it 'attaches the description to the disclosure attributes' do
        expect(data.first['properties']['disclosure_attributes'][0]).to eq(valid_coordinates_society['description'])
      end

      it 'returns the coordinates with the correct address' do
        expect(data.first['properties']['disclosure_attributes'][1]).to eq(valid_coordinates_society['address'].titleize)
      end

      it 'parses the date correct for the from date' do
        expect(data.first['properties']['disclosure_attributes'][2]).to eq('Committed on 03/18/2016')
      end

      it 'displays the correct link for the source' do
        expect(data.first['properties']['disclosure_attributes'][3]).to eq("<a href=www.data_society.org>Data Source</a>")
      end

      it 'returns the correct color for the marker' do
        expect(data.first['properties']['color']).to eq('#6B7D96')
      end
    end
  end
end
