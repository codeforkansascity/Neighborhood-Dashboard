RSpec.describe Entities::Vacancy::DangerousBuilding do
  let(:data_hash) {
    {
      'address' => 'Address 1',
      'location' => {
        'coordinates' => [-50, 100]
      },
      'statusofcase' => 'statusofcase'
    }
  }

  let(:metadata) { {'viewLastModified' => 1433307658} }

  subject{ Entities::Vacancy::DangerousBuilding.deserialize(data_hash) }

  describe '#properties' do
    it 'sets the color to #ffffff' do
      expect(subject.properties[:color]).to eq('#ffffff')
    end
  end

  describe '#latitude' do
    it 'gets the latitude from the geometry' do
      expect(subject.latitude).to eq(100)
    end
  end

  describe '#longitude' do
    it 'gets the longitude from the geometry' do
      expect(subject.longitude).to eq(-50)
    end
  end
end