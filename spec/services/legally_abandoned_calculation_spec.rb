require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation do
  let(:neighborhood) { double(name: 'Neighborhood')}
  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation.new(neighborhood) }

  let(:vacant_registry_failures) { double }
  let(:tax_delinquent_datasets) { double }
  let(:code_violation_count) { double }
  let(:three_eleven_data) { double }
  let(:dangerous_buildings) { double }

  let(:address_one) {
    {
      address: '1601 Test St.'
    }
  }

  let(:address_two) {
    {
      address: '1602 Test St.'
    }
  }

  let(:address_one_entity) {
    double(legally_abandoned?: true, to_h: address_one)
  }

  let(:address_two_entity) {
    double(legally_abandoned?: false, to_h: address_two)
  }

  before do
    allow(Entities::LegallyAbandonedCalculation::Item).to receive(:new)
      .with(address_one[:address])
      .and_return(address_one_entity)

    allow(Entities::LegallyAbandonedCalculation::Item).to receive(:new)
      .with(address_two[:address])
      .and_return(address_two_entity)

    allow(NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations).to receive(:new)
      .with(neighborhood)
      .and_return(vacant_registry_failures)

    allow(vacant_registry_failures).to receive(:calculated_data)
      .and_return({'1601 Test St.' => {}, '1602 Test St.' => {}})

    allow(NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent).to receive(:new)
      .with(neighborhood)
      .and_return(tax_delinquent_datasets)

    allow(tax_delinquent_datasets).to receive(:calculated_data)
      .and_return({'1601 Test St.' => {}, '1602 Test St.' => {}})

    allow(NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount).to receive(:new)
      .with(neighborhood)
      .and_return(code_violation_count)

    allow(code_violation_count).to receive(:calculated_data)
      .and_return({'1601 Test St.' => {}, '1602 Test St.' => {}})

    allow(NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData).to receive(:new)
      .with(neighborhood)
      .and_return(three_eleven_data)

    allow(three_eleven_data).to receive(:calculated_data)
      .and_return({'1601 Test St.' => {}, '1602 Test St.' => {}})

    allow(NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings).to receive(:new)
      .with(neighborhood)
      .and_return(dangerous_buildings)

    allow(dangerous_buildings).to receive(:calculated_data)
      .and_return({'1601 Test St.' => {}, '1602 Test St.' => {}})

    allow(address_one_entity).to receive(:vacant_registry_failure_data=)
    allow(address_one_entity).to receive(:tax_delinquent_data=)
    allow(address_one_entity).to receive(:address_violation_count=)
    allow(address_one_entity).to receive(:three_eleven_data=)
    allow(address_one_entity).to receive(:dangerous_buildings=)

    allow(address_two_entity).to receive(:vacant_registry_failure_data=)
    allow(address_two_entity).to receive(:tax_delinquent_data=)
    allow(address_two_entity).to receive(:address_violation_count=)
    allow(address_two_entity).to receive(:three_eleven_data=)
    allow(address_two_entity).to receive(:dangerous_buildings=)
  end

  it 'returns a hash of all the addresses that are deemed to be legally abandoned' do
    expect(dataset.vacant_indicators).to eq([address_one])
  end  
end
