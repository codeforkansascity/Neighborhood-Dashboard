require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent do
  let(:neighborhood) { double(name: 'Neighborhood', address_source_uri: 'http://data.hax') }

  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent.new(neighborhood) }
  let(:addresses) do
    [
      {
        'street_address' => 'Address 1',
        'census_latitude' => '90.0',
        'census_longitude' => '90.0'
      },
      {
        'street_address' => 'Address 2',
        'census_latitude' => '90.0',
        'census_longitude' => '90.0',
        'county_delinquent_tax_2010' => '45',
        'county_delinquent_tax_2011' => '45',
        'county_delinquent_tax_2012' => '45',
        'county_delinquent_tax_2013' => '45',
        'county_delinquent_tax_2014' => '45',
        'county_delinquent_tax_2015' => '0'
      },
      {
        'street_address' => 'Address 3',
        'census_latitude' => '90.0',
        'census_longitude' => '90.0',
        'county_delinquent_tax_2010' => '45',
        'county_delinquent_tax_2011' => '45',
        'county_delinquent_tax_2012' => '0',
        'county_delinquent_tax_2013' => '45',
        'county_delinquent_tax_2014' => '45',
        'county_delinquent_tax_2015' => '50'
      },
    ]
  end

  before do
    allow(neighborhood).to receive(:addresses).and_return(addresses)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }
    context 'when the tax_delinquent is 1-3 consective years ending with with 2015' do
      it 'adds the consecutive years to the returned hash' do
        expect(calculated_data['address 1'][:consecutive_years]).to eq(0)
        expect(calculated_data['address 2'][:consecutive_years]).to eq(0)
        expect(calculated_data['address 3'][:consecutive_years]).to eq(3)
      end

      it 'adds the latitude and longitude of the addresses to the returned hash' do
        expect(calculated_data['address 1'][:longitude]).to eq(90)
        expect(calculated_data['address 1'][:latitude]).to eq(90)

        expect(calculated_data['address 2'][:longitude]).to eq(90)
        expect(calculated_data['address 2'][:latitude]).to eq(90)

        expect(calculated_data['address 3'][:longitude]).to eq(90)
        expect(calculated_data['address 3'][:latitude]).to eq(90)
      end
    end
  end
 end