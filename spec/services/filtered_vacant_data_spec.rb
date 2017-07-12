require 'rails_helper'

RSpec.describe NeighborhoodServices::FilteredVacantData do
  subject { NeighborhoodServices::FilteredVacantData.new(neighborhood) }
  let(:filters) { {'filters' => []}}
  let(:neighborhood) { double(id: 1, name: 'Neighborhood')}
  let(:mock_tax_delinquent_data) { double(data: 'tax-delinquent') }
  let(:mock_dangerous_building_data) { double(data: 'dangerous-building') }
  let(:mock_land_bank_data) { double(data: 'land-bank-data') }
  let(:mock_three_eleven_data) { double(data: 'three-elevent') }
  let(:mock_property_violations_data) { double(data: 'property-violation') }

  before do
    allow(NeighborhoodServices::VacancyData::TaxDelinquent).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_tax_delinquent_data)

    allow(NeighborhoodServices::VacancyData::DangerousBuildings).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_dangerous_building_data)

    allow(NeighborhoodServices::VacancyData::LandBank).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_land_bank_data)

    allow(NeighborhoodServices::VacancyData::ThreeEleven).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_three_eleven_data)

    allow(NeighborhoodServices::VacancyData::PropertyViolations).to receive(:new)
      .with(neighborhood, filters)
      .and_return(mock_property_violations_data)
  end

  describe '#filtered_vacant_data' do
    context 'when no filters are passed into the vacant data' do
      it 'returns an empty array' do
        expect(subject.filtered_vacant_data(filters)).to eq([])
      end
    end

    context 'when it contains a tax delinquent filter' do
      NeighborhoodServices::VacancyData::TaxDelinquent::POSSIBLE_FILTERS.each do |filter|
        let(:filters) { {'filters' => [filter]} }

        it 'returns an empty array' do
          expect(subject.filtered_vacant_data(filters)).to eq([mock_tax_delinquent_data.data])
        end
      end
    end

    context 'when it contains a dangerous building filter' do
      NeighborhoodServices::VacancyData::DangerousBuildings::POSSIBLE_FILTERS.each do |filter|
        let(:filters) { {'filters' => [filter]} }

        it 'returns an empty array' do
          expect(subject.filtered_vacant_data(filters)).to eq([mock_dangerous_building_data.data])
        end
      end
    end

    context 'when it contains a land bank data filter' do
      NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS.each do |filter|
        let(:filters) { {'filters' => [filter]} }

        it 'returns an empty array' do
          expect(subject.filtered_vacant_data(filters)).to eq([mock_land_bank_data.data])
        end
      end
    end

    context 'when it contains a three eleven data filter' do
      NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS.each do |filter|
        let(:filters) { {'filters' => [filter]} }

        it 'returns an empty array' do
          expect(subject.filtered_vacant_data(filters)).to eq([mock_three_eleven_data.data])
        end
      end
    end

    context 'when it contains a property violation data filter' do
      NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS.each do |filter|
        let(:filters) { {'filters' => [filter]} }

        it 'returns an empty array' do
          expect(subject.filtered_vacant_data(filters)).to eq([mock_property_violations_data.data])
        end
      end
    end
  end
end
