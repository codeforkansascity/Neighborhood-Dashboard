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
end