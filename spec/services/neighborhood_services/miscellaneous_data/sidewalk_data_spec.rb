describe NeighborhoodServices::MiscellaneousData::SidewalkData do
  subject { NeighborhoodServices::MiscellaneousData::SidewalkData.new(neighborhood, filters) }

  let(:neighborhood) { double(id: 1)}
  let(:filters) { {} }

  let(:sidewalk_data_one) { {address: 'First'} }
  let(:sidewalk_data_two) { {address: 'Second'} }

  let(:sidewalk_data_one_deserialized) { double(mappable?: true) }
  let(:sidewalk_data_two_deserialized) { double(mappable?: false) }

  let(:sidewalk_data) {
    [sidewalk_data_one, sidewalk_data_two]
  }

  let(:mock_data_request) {
    double(metadata: {}, request_data: sidewalk_data)
  }

  before do
    allow(Entities::ThreeEleven::Sidewalk).to receive(:deserialize)
      .with(sidewalk_data_one)
      .and_return(sidewalk_data_one_deserialized)

    allow(Entities::ThreeEleven::Sidewalk).to receive(:deserialize)
      .with(sidewalk_data_two)
      .and_return(sidewalk_data_two_deserialized)

    allow(sidewalk_data_one_deserialized).to receive(:metadata=)
    allow(sidewalk_data_two_deserialized).to receive(:metadata=)

    allow(KcmoDatasets::ThreeElevenCases).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_data_request)
  end

  describe '#data' do
    it 'returns an array of deserialized sidewalk entities that are mappable' do
      expect(subject.data).to eq([sidewalk_data_one_deserialized])
    end

    it 'attaches metadata to all of the deserialized entities' do
      subject.data
      expect(sidewalk_data_one_deserialized).to have_received(:metadata=)
      expect(sidewalk_data_two_deserialized).to have_received(:metadata=)
    end
  end
end