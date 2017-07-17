describe NeighborhoodServices::MiscellaneousData::ProblemRenters do
  subject { NeighborhoodServices::MiscellaneousData::ProblemRenters.new(neighborhood, filters) }

  let(:filters) { [] }
  let(:non_renter_property) {
    {
      'county_owner_address' => 'Owner Address',
      'street_address' => 'Owner Address'
    }
  }

  let(:renter_property) {
    {
      'county_owner_address' => 'Owner Address',
      'street_address' => 'Non Owner Address'
    }
  }

  let(:property_violations_client) { double }


  let(:violation_one_hash) { {address: 'Non Owner Address'} }
  let(:violation_two_hash) { {address: 'Non Owner Address'} }
  let(:violation_three_hash) { {address: 'Other Address'} }
  let(:violations_data) { [violation_one_hash, violation_two_hash, violation_three_hash]}

  let(:violation_one) { double(address: 'Non Owner Address') }
  let(:violation_two) { double(address: 'Non Owner Address') }
  let(:violation_three) { double(address: 'Other Address') }
  let(:violations) { [violation_one, violation_two, violation_three] }

  let(:addresses) { [renter_property, non_renter_property] }
  let(:neighborhood) { double(id: 10, addresses: addresses) }

  before do
    allow(KcmoDatasets::PropertyViolations).to receive(:new)
      .with(neighborhood)
      .and_return(property_violations_client)

    allow(property_violations_client).to receive(:open_cases)
      .and_return(property_violations_client)

    allow(property_violations_client).to receive(:request_data)
      .and_return(violations_data)
  end

  it 'returns all addresses that have a different owner and contain at least two code violations' do
    expect(subject.data.first.address).to eq('Non Owner Address')
  end
end
