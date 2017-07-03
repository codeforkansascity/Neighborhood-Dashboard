require 'rails_helper'

RSpec.describe Neighborhood, :type => :model do
  subject { Neighborhood.new(neighborhood_data) }

  let(:neighborhood_data) {
    {
      id: 5,
      code: 115,
      name: 'test-neighborhood'
    }
  }

  describe '#addresses' do
    context' when data does not exist for the given neighborhood' do
      before do
        allow(HTTParty).to receive(:get)
          .with(URI::escape("http://dev-api.codeforkc.org/address-by-neighborhood/V0/#{subject.name}?city=Kansas City&state=MO"))
          .and_return({})
      end

      it 'returns an empty array' do
        expect(subject.addresses).to eq([])
      end
    end

    context 'when the address query throws an error' do
      before do
        allow(HTTParty).to receive(:get).and_raise("Bad Request")
      end

      it 'returns an empty array' do
        expect(subject.addresses).to eq([])
      end
    end

    context 'when the address query returns successfully' do
      let(:addresses) { 
        [
          "address-1",
          "address-2",
          "address-3",
          "address-4",
          "address-5"
        ]
      }

      before do
        allow(HTTParty).to receive(:get)
          .with(URI::escape("http://dev-api.codeforkc.org/address-by-neighborhood/V0/#{subject.name}?city=Kansas City&state=MO"))
          .and_return({'data' => addresses}.to_json)
      end

      it 'returns an empty array' do
        expect(subject.addresses).to eq(addresses)
      end
    end
  end
end
