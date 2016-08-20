require 'kcmo_datasets/property_violations'

RSpec.describe KcmoDatasets::PropertyViolations do
  let(:neighborhood) { double }
  let(:primary_dataset) { KcmoDatasets::PropertyViolations.new(neighborhood) } 
  let(:expected_endpoint) { 'ha6k-d6qu' }

  before do
    allow(neighborhood).to receive(:within_polygon_query).and_return('[],[],[]')
    allow(SocrataClient).to receive(:get).and_return([])
  end

  describe '#vacant_registry_failure' do
    it 'adds vacant_called_in to requested datasets' do
      primary_dataset.vacant_registry_failure
      expect(primary_dataset.requested_datasets.include?('vacant_registry_failure')).to eq(true)
    end    
  end

  describe '#request_data' do
    context 'when there are no requested datasets' do
      it 'sends a request to the dataset with just the neighborhood coordinates' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_endpoint,
            'SELECT * WHERE [],[],[]'
          )
      end
    end

    context 'when the user has requested vacant_registry_failure data' do
      let(:expected_vacant_registry_codes) {
        [
          "'NSVACANT'", 
          "'NSBOARD01'"
        ]
      }

      let(:expected_filter_query) {
        "violation_code in (#{expected_vacant_registry_codes.join(',')})"
      }

      before do
        primary_dataset.vacant_registry_failure
      end

      it 'sends a request for vacant registry failure data to the endpoint' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_endpoint,
            "SELECT * WHERE [],[],[] AND (#{expected_filter_query})"
          )
      end
    end
  end
end
