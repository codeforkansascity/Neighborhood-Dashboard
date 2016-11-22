require 'rails_helper'

RSpec.describe NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent do
  let(:neighborhood) { double(name: 'Neighborhood', address_source_uri: 'http://data.hax') }

  let(:dataset) { NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent.new(neighborhood) }
  let(:addresses) do
    {
      'data' => [
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
          'county_delinquent_tax_2012' => '45',
          'county_delinquent_tax_2013' => '45',
          'county_delinquent_tax_2014' => '45',
          'county_delinquent_tax_2015' => '45'
        },
        {
          'street_address' => 'Address 4',
          'census_latitude' => '90.0',
          'census_longitude' => '90.0',
          'county_delinquent_tax_2010' => '45',
          'county_delinquent_tax_2011' => '45',
          'county_delinquent_tax_2012' => '45',
          'county_delinquent_tax_2013' => '45',
          'county_delinquent_tax_2014' => '0',
          'county_delinquent_tax_2015' => '45'
        },
        {
          'street_address' => 'Address 5',
          'census_latitude' => '90.0',
          'census_longitude' => '90.0',
          'county_delinquent_tax_2010' => '45',
          'county_delinquent_tax_2011' => '45',
          'county_delinquent_tax_2012' => '45',
          'county_delinquent_tax_2013' => '0',
          'county_delinquent_tax_2014' => '45',
          'county_delinquent_tax_2015' => '45'
        },
        {
          'street_address' => 'Address 6',
          'census_latitude' => '90.0',
          'census_longitude' => '90.0',
          'county_delinquent_tax_2010' => '45',
          'county_delinquent_tax_2011' => '45',
          'county_delinquent_tax_2012' => '0',
          'county_delinquent_tax_2013' => '45',
          'county_delinquent_tax_2014' => '45',
          'county_delinquent_tax_2015' => '45'
        }
      ]
    }
  end

  before do
    allow(neighborhood).to receive(:addresses).and_return(addresses)
  end

  describe '#calculated_data' do
    let(:calculated_data) { dataset.calculated_data }

    context 'when an address does not have tax delinquent data' do
      it 'does not add the address to the returned hash' do
        expect(calculated_data['address 1']).to be_nil
      end
    end

    context 'when the tax delinquent is 0 for 2015' do
      it 'does not add the address to the returned hash' do
        expect(calculated_data['address 2']).to be_nil
      end
    end

    context 'when the tax_delinquent is 1-3 consective years ending with with 2015' do
      it 'adds the address with a point value of 1 to the returned hash' do
        expect(calculated_data['address 4'][:points]).to eq(1)

        expect(calculated_data['address 5'][:points]).to eq(1)
      end

      it 'adds the vacant display with the appropriate amount of years' do
        expect(calculated_data['address 4'][:disclosure_attributes][1]).to eq('1 year(s) Tax Delinquent')

        expect(calculated_data['address 5'][:disclosure_attributes][1]).to eq('2 year(s) Tax Delinquent')
      end

      it 'adds the latitude and longitude of the addresses to the returned hash' do
        expect(calculated_data['address 4'][:longitude]).to eq(90)
        expect(calculated_data['address 4'][:latitude]).to eq(90)

        expect(calculated_data['address 5'][:longitude]).to eq(90)
        expect(calculated_data['address 5'][:latitude]).to eq(90)
      end
    end

    context 'when the tax_delinquent is 3+ years starting with 2015' do
      it 'adds the address with a point value of 1 to the returned hash' do
        expect(calculated_data['address 3'][:points]).to eq(2)

        expect(calculated_data['address 6'][:points]).to eq(2)
      end

      it 'adds the vacant display with the appropriate amount of years' do
        expect(calculated_data['address 3'][:disclosure_attributes][1]).to eq('6 year(s) Tax Delinquent')

        expect(calculated_data['address 6'][:disclosure_attributes][1]).to eq('3 year(s) Tax Delinquent')
      end

      it 'adds the latitude and longitude of the addresses to the returned hash' do
        expect(calculated_data['address 3'][:longitude]).to eq(90)
        expect(calculated_data['address 6'][:latitude]).to eq(90)

        expect(calculated_data['address 3'][:longitude]).to eq(90)
        expect(calculated_data['address 6'][:latitude]).to eq(90)
      end
    end
  end
 end