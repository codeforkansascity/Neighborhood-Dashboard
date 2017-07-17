RSpec.describe Entities::AddressApi::PotentialRenterProblem do
  subject { Entities::AddressApi::PotentialRenterProblem.deserialize(data_hash) }

  let(:data_hash) {
    {
      full_address: 'Full Address',
      county_owner: 'Test Owner',
      county_owner_address: 'County Owner Address',
      county_owner_city: 'Test City',
      county_owner_state: 'Test State',
      county_owner_zip: 'Test Zip',
      city: 'Test Main City',
      state: 'Test Main State',
      census_zip: 'Test Census Zip',
      street_address: 'Test Streed Address'
    }
  }
  
  let(:violation_one) { double(violation_description: 'Violation 1') }
  let(:violation_two) { double(violation_description: 'Violation 2') }

  describe '#properties' do
    it 'sets the color to white' do
      expect(subject.properties['color']).to eq('#ffffff')
    end
  end

  describe '#add_violation' do
    it 'adds a violation to the violations' do
      subject.add_violation(violation_one)
      expect(subject.violations).to eq([violation_one])
    end
  end

  describe '#disclosure_attributes' do
    before do
      subject.instance_variable_set(:@violations, [violation_one, violation_two])
    end

    it 'contains the full address of the neighborhood' do
      expect(subject.disclosure_attributes).to include(
        "<address>#{data_hash[:street_address].titleize}<br/>#{data_hash[:city].try(&:titleize)} #{data_hash[:state]}, #{data_hash[:census_zip]}</address>"
      )
    end

    it 'contains the county_owner_address of the neighborhood' do
      expect(subject.disclosure_attributes).to include(
        "<address>#{data_hash[:county_owner_address]}<br/>Test City Test State, Test Zip</address>"
      )
    end

    it 'contains the county_owner of the neighborhood' do
      expect(subject.disclosure_attributes).to include(data_hash[:county_owner])
    end
  end
end
