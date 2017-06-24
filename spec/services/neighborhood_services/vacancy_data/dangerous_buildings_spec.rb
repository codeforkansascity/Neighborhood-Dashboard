require 'rails_helper'

RSpec.describe NeighborhoodServices::VacancyData::DangerousBuildings do
  subject { NeighborhoodServices::VacancyData::DangerousBuildings.new(neighborhood, filters) }

  let(:filters) { {} }
  let(:neighborhood) { double(id: 1) }
  let(:metadata) { {'date' => 'today'} }

  let(:dangerous_building_one_hash) { {'id' => 1} }
  let(:dangerous_building_two_hash) { {'id' => 2} }
  let(:dangerous_building_three_hash) { {'id' => 3} }

  let(:dangerous_building_one) {
    double(mappable?: true, to_h: {'building' => 1})
  }

  let(:dangerous_building_two) {
    double(mappable?: false, to_h: {'building' => 2})
  }

  let(:dangerous_building_three) {
    double(mappable?: true, to_h: {'building' => 3})
  }

  let(:mock_dataset) {
    double(
      request_data: [
        dangerous_building_one_hash,
        dangerous_building_two_hash,
        dangerous_building_three_hash
      ],
      metadata: metadata
    )
  }

  describe '#data' do
    before do
      allow(KcmoDatasets::DangerousBuildings).to receive(:new)
        .and_return(mock_dataset)

      allow(Entities::Vacancy::DangerousBuilding).to receive(:deserialize)
        .with(dangerous_building_one_hash)
        .and_return(dangerous_building_one)

      allow(Entities::Vacancy::DangerousBuilding).to receive(:deserialize)
        .with(dangerous_building_two_hash)
        .and_return(dangerous_building_two)

      allow(Entities::Vacancy::DangerousBuilding).to receive(:deserialize)
        .with(dangerous_building_three_hash)
        .and_return(dangerous_building_three)

      allow(dangerous_building_one).to receive(:metadata=)
      allow(dangerous_building_two).to receive(:metadata=)
      allow(dangerous_building_three).to receive(:metadata=)

      subject.data
    end

    it 'returns a proper hash of the data' do
      expect(subject.data).to eq(
        [
          dangerous_building_one.to_h,
          dangerous_building_three.to_h
        ]
      )
    end

    it 'adds the metadata from the dataset to all of the entities' do
      expect(dangerous_building_one).to have_received(:metadata=).with(metadata)
      expect(dangerous_building_two).to have_received(:metadata=).with(metadata)
      expect(dangerous_building_three).to have_received(:metadata=).with(metadata)
    end
  end
end
