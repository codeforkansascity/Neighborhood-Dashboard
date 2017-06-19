RSpec.describe Entities::GeoJson do
  subject { Entities::GeoJson.deserialize(data_hash)}

  let(:data_hash) { {type: 'Feature', } }

  describe '#feature' do
    it 'sets the feature attribute when passed as part of the hash' do
      expect(subject.type).to eq('Feature')
    end
  end

  describe '#to_h' do
    let(:mock_properties) { {property: 'Property'} }
    let(:mock_geometry) { {type: 'Point', coordinates: [[23],[23]]} }
    let(:mock_disclosure_attributes) { ['<p>Test Paragraph/p>'] }
    let(:hash) { subject.to_h }

    before do
      allow(subject).to receive(:properties).and_return(mock_properties)
      allow(subject).to receive(:geometry).and_return(mock_geometry)
      allow(subject).to receive(:disclosure_attributes).and_return(mock_disclosure_attributes)
    end

    it 'adds the properties to the hash' do
      expect(hash[:type]).to eq('Feature')
    end

    it 'adds the geometry to the hash' do
      expect(hash[:geometry]).to eq(mock_geometry)
    end

    it 'adds the disclosure attributes to the hash' do
      expect(hash[:properties][:disclosure_attributes]).to eq(mock_disclosure_attributes)
    end
  end
end
