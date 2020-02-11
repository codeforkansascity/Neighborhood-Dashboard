require 'rails_helper'

RSpec.describe GoogleMaps::StaticGenerator do
  subject { GoogleMaps::StaticGenerator.new(neighborhood, markers)}

  let(:coordinate_1) { double(latitude: '10', longtitude: '10')}
  let(:coordinate_2) { double(latitude: '15', longtitude: '15')}
  let(:coordinate_3) { double(latitude: '20', longtitude: '20')}
  let(:coordinates) { [coordinate_1, coordinate_2, coordinate_3] }
  let(:neighborhood_center) { {latitude: '11', longtitude: '11'} }

  let(:neighborhood) { double(coordinates: coordinates, center: neighborhood_center) }
  let(:polyfill_coordinates) { coordinates.map{|coord| [coord.latitude, coord.longtitude]}}
  let(:markers){ [] }

  before do
    allow(URI).to receive(:escape).with(anything) do |value|
      value
    end

    allow(Polylines::Encoder).to receive(:encode_points)
      .with(polyfill_coordinates)
      .and_return('encoded_polygon')
  end

  describe '#generate_static_api_uri' do
    it 'includes the correct api key' do
      expect(subject.generate_static_api_uri).to include('key=AIzaSyAhJj7KI0SOUpT3-dUrT5bGHibT9fD7Zd0')
    end

    it 'includes the correct size' do
      expect(subject.generate_static_api_uri).to include('size=800x400')
    end

    it 'includes the correct zoom' do
      expect(subject.generate_static_api_uri).to include('zoom=15')
    end

    context 'when the neighborhood has a center' do
      it 'includes the center parameter on the uri' do
        expect(subject.generate_static_api_uri).to include('center=11,11')
      end
    end

    context 'when the neighborhood does not have a center' do
      let(:neighborhood_center) { {} }

      it 'does not include the center parameter on the uri' do
        expect(subject.generate_static_api_uri).to_not include('center=')
      end
    end

    it 'includes the encoded polygon with correct styles' do
      expect(subject.generate_static_api_uri).to include(
        'path=weight:3|fillcolor:0x00000033|color:0x000000|enc:encoded_polygon'
      )
    end

    context 'when the map contains at least one marker' do
      let(:markers) do 
        [
          {
            color: 'ffffff',
            label: '20',
            data: double(latitude: '10', longitude: '11'),
          }
        ]
      end

      it 'adds the marker to the url' do
        expect(subject.generate_static_api_uri).to include('&markers=color:0xffffff|label:20|10,11')
      end
    end

    context 'when the map contains no markers' do
      it 'does not include markers as a query parameter' do
        expect(subject.generate_static_api_uri).to_not include('markers=')
      end
    end
  end
end
