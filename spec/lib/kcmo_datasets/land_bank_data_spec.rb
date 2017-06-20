require 'rails_helper'
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
    context 'when no filters exist on the dataset' do
      it 'includes the neighborhood coordinates when requesting data from the data source' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_datasource,
            'SELECT * WHERE [],[],[]'
          )
      end
    end

    context 'when "demo_needed" is attached to the filters' do
      before do
        primary_dataset.filters = {
          data_filters: ['demo_needed']
        }
      end

      it 'includes the filter required for demo needed' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_datasource,
            "SELECT * WHERE [],[],[] AND (demo_needed='Y')"
          )
      end
    end

    context 'when "foreclosed" is attached to the data filters' do
      before do
        primary_dataset.filters = {
          data_filters: ['foreclosed']
        }
      end

      it 'includes the filter required for forclosed data' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_datasource,
            "SELECT * WHERE [],[],[] AND ((foreclosure_year IS NOT NULL))"
          )
      end
    end

    context 'when "landbank_vacant_lots" is attached to the data filters' do
      before do
        primary_dataset.filters = {
          data_filters: ['landbank_vacant_lots']
        }
      end

      it 'includes the filter required for demo needed' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_datasource,
            "SELECT * WHERE [],[],[] AND (property_condition like 'Vacant lot or land%')"
          )
      end
    end

    context 'when "landbank_vacant_structures" is attached to the data filters' do
      before do
        primary_dataset.filters = {
          data_filters: ['landbank_vacant_structures']
        }
      end

      it 'includes the filter required for demo needed' do
        primary_dataset.request_data
        expect(SocrataClient).to have_received(:get)
          .with(
            expected_datasource,
            "SELECT * WHERE [],[],[] AND (property_condition like 'Structure%')"
          )
      end
    end
  end
end
