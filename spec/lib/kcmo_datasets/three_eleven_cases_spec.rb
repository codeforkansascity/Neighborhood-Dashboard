require 'kcmo_datasets/three_eleven_cases'

RSpec.describe KcmoDatasets::ThreeElevenCases do
  let(:neighborhood) { double }
  let(:primary_dataset) { KcmoDatasets::ThreeElevenCases.new(neighborhood) } 
  let(:expected_endpoint) { 'cyqf-nban' }

  before do
    allow(neighborhood).to receive(:within_polygon_query).and_return('[],[],[]')
    allow(SocrataClient).to receive(:get).and_return({})
  end

  describe '#vacant_called_in_violations' do    
    it 'adds vacant_called_in to requested datasets' do
      primary_dataset.vacant_called_in_violations
      expect(primary_dataset.requested_datasets.include?('vacant_structure')).to eq(true)
    end
  end

  describe '#open_cases' do    
    it 'adds open_cases to requested datasets' do
      primary_dataset.open_cases
      expect(primary_dataset.requested_datasets.include?('open_three_eleven')).to eq(true)
    end
  end

  describe '#sidewalk_issues' do
    it 'adds sidewalk_issues to requested datasets' do
      primary_dataset.sidewalk_issues
      expect(primary_dataset.requested_datasets.include?('sidewalk_issues')).to eq(true)
    end
  end

  describe '#request_data' do
    context 'when no datasets are requested from this endpoint' do
      it 'sends a query with just the polygon coordinates to the socrata service' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get).with(
          expected_endpoint, 
          "SELECT * WHERE [],[],[]"
        )
      end
    end

    context 'when the dataset is looking for vacant_structure' do
      let(:expected_request_types) {
        [
          "'Animals / Pets-Rat Treatment-Vacant Home'",
          "'Animals / Pets-Rat Treatment-Vacant Property'",
          "'Cleaning vacant Land Trust Lots'",
          "'Mowing / Weeds-Public Property-City Vacant Lot'",
          "'Nuisance Violations on Private Property Vacant Structure'",
          "'Vacant Structure Open to Entry'"
        ]
      }

      let(:expected_filter_query) {
        "request_type in (#{expected_request_types.join(',')})"
      }

      before do
        primary_dataset.vacant_called_in_violations
      end

      it 'sends a query with a request for "vacant called in violations"' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get).with(
          expected_endpoint, 
          "SELECT * WHERE [],[],[] AND (#{expected_filter_query})"
        )
      end
    end

    context 'when the dataset is looking for sidewalk_issues' do
      let(:expected_filter_query) {
        "work_group='Public Works-Capital Projects-Sidewalks' AND status='OPEN'"
      }

      before do
        primary_dataset.sidewalk_issues
      end

      it 'sends a query with a request looking for issues with a sidewalk request type' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get).with(
          expected_endpoint, 
          "SELECT * WHERE [],[],[] AND (#{expected_filter_query})"
        )
      end
    end

    context 'when the dataset is looking for vacant_called_in' do
      let(:expected_filter_query) {
        "request_type in (#{expected_request_types.join(',')})"
      }

      before do
        primary_dataset.open_cases
      end

      it 'sends a query with a request for "vacant called in violations"' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get).with(
          expected_endpoint, 
          "SELECT * WHERE [],[],[] AND (status='OPEN')"
        )
      end
    end
  end
end
