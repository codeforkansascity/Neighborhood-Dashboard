require 'rails_helper'

RSpec.describe NeighborhoodServices::Crime do
  let(:neighborhood) { double(id: 2, name: 'Neighborhood 1') }
  let(:options) { {} }
  let(:mock_kcmo_crime) { double() }

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
    let(:mappable_coordinate_hash) { {mappable: true} }
    let(:mappable_coordinate) { 
      double(mappable?: true, to_h: mappable_coordinate_hash) 
    }

    let(:non_mappable_coordinate_hash) { {mappable: false} }
    let(:non_mappable_coordinate) { 
      double(mappable?: false, to_h: non_mappable_coordinate_hash) 
    }

    let(:fetched_data) {
      [
        mappable_coordinate_hash, 
        non_mappable_coordinate_hash
      ]
    }

    before do
      allow(mock_kcmo_crime).to receive(:query_data)
        .and_return(fetched_data)

      allow(Entities::Crime).to receive(:deserialize)
        .with(mappable_coordinate_hash)
        .and_return(mappable_coordinate)

      allow(Entities::Crime).to receive(:deserialize)
        .with(non_mappable_coordinate_hash)
        .and_return(non_mappable_coordinate)
    end

    it 'only returns items that are mappable' do
      expect(NeighborhoodServices::Crime.new(neighborhood.id, options).mapped_coordinates).to eq([mappable_coordinate_hash])
    end
  end
end
