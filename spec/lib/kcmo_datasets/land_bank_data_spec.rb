require 'kcmo_datasets/land_bank_data'

RSpec.describe KcmoDatasets::LandBankData do
  let(:neighborhood) { double }
  let(:primary_dataset) { KcmoDatasets::LandBankData.new(neighborhood) }
  let(:expected_datasource) { 'n653-v74j' }

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
