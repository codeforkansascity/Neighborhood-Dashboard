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

  let(:coordinates) { [] }

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

  describe '#center' do
    context 'when the neighborhood does not have coordinates' do
      it 'returns an empty hash' do
        expect(subject.center).to eq({})
      end
    end

    context 'when the neighborhood has coordinates' do
      let (:coordinates) { 
        [
          double(latitude: 1, longtitude: 1),
          double(latitude: 2, longtitude: 2),
          double(latitude: 3, longtitude: 3),
          double(latitude: 4, longtitude: 4),
        ] 
      }

      let(:expected_center) { {latitude: 2.5, longtitude: 2.5} }

      before do
        allow(subject).to receive(:coordinates).and_return(coordinates)
      end

      it 'calculates the correct center for the neighborhood' do
        expect(subject.center).to eq(expected_center)
      end
    end
  end
end
