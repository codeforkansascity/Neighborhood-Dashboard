RSpec.describe NeighborhoodServices::MiscellaneousData do
  subject { NeighborhoodServices::MiscellaneousData.new(neighborhood) }

  let(:filters) { {} }
  let(:neighborhood) { double }

  let(:mock_three_eleven_service_client) { double }
  let(:mock_three_eleven_service_data) { double }

  let(:mock_problem_landlord_client) { double }
  let(:mock_problem_landlord_data) { double }

  before do
    allow(NeighborhoodServices::MiscellaneousData::SidewalkData).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_three_eleven_service_client)

    allow(mock_three_eleven_service_client).to receive(:data)
      .and_return(mock_three_eleven_service_data)

    allow(NeighborhoodServices::MiscellaneousData::ProblemLandlords).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_problem_landlord_client)

    allow(mock_problem_landlord_client).to receive(:data)
      .and_return(mock_problem_landlord_data)
  end

  describe '#filtered_data' do
    context 'when the filters contain sidewalk data' do
      let(:filters) { {'filters' => ['sidewalk_issues']} }

      it 'adds the sidewalk data to the returned data' do
        expect(subject.filtered_data(filters)).to eq([mock_three_eleven_service_data])
      end
    end

    context 'when the filters contain problem landlords' do
      let(:filters) { {'filters' => ['problem_landlords']} }

      it 'adds the sidewalk data to the returned data' do
        expect(subject.filtered_data(filters)).to eq([mock_problem_landlord_data])
      end
    end
  end
end
