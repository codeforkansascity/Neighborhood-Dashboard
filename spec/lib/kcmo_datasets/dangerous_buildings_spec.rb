require 'kcmo_datasets/dangerous_buildings'

RSpec.describe KcmoDatasets::DangerousBuildings do
  let(:neighborhood) { double }
  let(:primary_dataset) { KcmoDatasets::DangerousBuildings.new(neighborhood) }
  let(:expected_datasource) { 'rm2v-mbk5' }

  before do
    allow(neighborhood).to receive(:within_polygon_query).and_return('[],[],[]')
    allow(SocrataClient).to receive(:get).and_return([])
  end

  describe '#request_data' do
    it 'includes the neighborhood coordinates when requesting data from the data source' do
      primary_dataset.request_data
      expect(SocrataClient).to have_received(:get)
        .with(
          expected_datasource,
          'SELECT * WHERE [],[],[]'
        )
    end
  end
end
