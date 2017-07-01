RSpec.describe Entities::LegallyAbandonedCalculation::Item do
  subject{ Entities::LegallyAbandonedCalculation::Item.new(address) }

  let(:address) { '1601 Testing St.' }
  let(:vacant_registry_failure_data) { {} }
  let(:tax_delinquent_data) { {} }
  let(:address_violation_count) { {} }
  let(:three_eleven_data) { {} }
  let(:dangerous_buildings) { {} }

  let(:mock_parcel_data_address_present) {
    [
      {
        'properties' => {
          'land_ban60' => "#{address}\nKansas City"
        },
        'geometry' => {
          'coordinates' => [[[0,20], [0,19], [2,15]]]
        }
      }
    ]
  }

  let(:mock_parcel_data_address_not_present) {
    [
      {
        'properties' => {
          'land_ban60' => "1928\nKansas City"
        },
        'geometry' => {
          'coordinates' => [[[0,20], [0,19], [2,15]]]
        }
      }
    ]
  }

  describe '#properties' do
    describe 'marker_type' do
      context 'when the item contains an address that is found on the geometric parcel' do
        before do
          allow(StaticData).to receive(:PARCEL_DATA).and_return(mock_parcel_data_address_present)
        end

        it 'sets the marker_type to nil' do
          expect(subject.properties[:marker_style]).to be_nil
        end
      end

      context 'when the item contains and address that does not exist in parcel data' do
        before do
          allow(StaticData).to receive(:PARCEL_DATA).and_return(mock_parcel_data_address_not_present)
        end

        it 'sets the marker_type to nil' do
          expect(subject.properties[:marker_style]).to eq('circle')
        end
      end
    end

    describe '#color' do
      context 'when the item has 6 total points' do
        before do
          allow(subject).to receive(:total_points).and_return(6)
        end

        it 'sets the color to #000' do
          expect(subject.properties[:color]).to eq('#000')
        end
      end

      context 'when the item has 5 total points' do
        before do
          allow(subject).to receive(:total_points).and_return(5)
        end

        it 'sets the color to #444' do
          expect(subject.properties[:color]).to eq('#444')
        end
      end

      context 'when the item has 4 total points' do
        before do
          allow(subject).to receive(:total_points).and_return(4)
        end

        it 'sets the color to #888' do
          expect(subject.properties[:color]).to eq('#888')
        end
      end

      context 'when the item has 3 total points' do
        before do
          allow(subject).to receive(:total_points).and_return(3)
        end

        it 'sets the color to #CCC' do
          expect(subject.properties[:color]).to eq('#CCC')
        end
      end

      context 'when the item has less than 3 total points' do
        before do
          allow(subject).to receive(:total_points).and_return(2)
        end

        it 'sets the color to nil' do
          expect(subject.properties[:color]).to be_nil
        end
      end
    end

    describe '#total_points' do
      before do
        allow(subject).to receive(:total_points).and_return(6)
      end

      it 'sets total_points to the total points associated to the item' do
        expect(subject.properties[:total_points]).to eq(6)
      end
    end
  end

  describe '#disclosure_attributes' do
    describe '@address headers' do
      it 'contains a paragraph with just a header saying "Address"' do
        expect(subject.disclosure_attributes).to include('<h3 class="info-window-header">Address</h3>')
      end

      context 'when data is not available from the delinquent data' do
        it 'contains a paragraph which has address without the zipcode information' do
          expect(subject.disclosure_attributes).to include('<address>1601 Testing St.<br/> , </address>')
        end
      end

      context 'when data is available from tax delinquent data' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, {
            city: 'Kansas City',
            zip: '64109',
            state: 'MO'
          })
        end

        it 'contains a paragraph giving the address location with the zipcode information' do
          expect(subject.disclosure_attributes).to include(
            '<address>1601 Testing St.<br/>Kansas City MO, 64109</address>'
          )
        end
      end
    end

    describe '@owner headers' do
      it 'contains a paragraph with just a header saying "Address"' do
        expect(subject.disclosure_attributes).to include('<h3 class="info-window-header">Owner</h3>')
      end

      context 'when data is available from tax delinquent data' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, {
            owner: 'Test Owner'
          })
        end

        it 'contains a paragraph giving the address location with the zipcode information' do
          expect(subject.disclosure_attributes).to include('Test Owner')
        end
      end

      context 'when data is not available from tax delinquent data' do
        it 'contains a paragraph giving the address location with the zipcode information' do
          expect(subject.disclosure_attributes).to include('Not Available')
        end
      end
    end

    describe '@three eleven headers' do
      let (:source_link) { "<a href='#{KcmoDatasets::ThreeElevenCases::SOURCE_URI}' target='_blank'><small>(Source)</small></a>" }

      context 'when three eleven data is not available' do
        it 'does not add any three eleven headers to the disclosure attributes' do
          expect(subject.disclosure_attributes).to_not include(
            'violation 1', 
            'violation 2',
            'Last Updated: 06/27/2017',
            "<h2 class='info-window-header'>311 Complaints</h2>&nbsp;#{source_link}"
          )
        end
      end

      context 'when three eleven data is available' do
        before do
          subject.instance_variable_set(:@three_eleven_data, {
            violations: ['violation 1', 'violation 2'],
            last_updated_date: '06/27/2017'
          })
        end

        it 'includes a source link to the three eleven data set' do
          expect(subject.disclosure_attributes).to include(
            "<h2 class='info-window-header'>311 Complaints</h2>&nbsp;#{source_link}"
          )
        end

        it 'attaches a paragraph for every individual violation' do
          expect(subject.disclosure_attributes).to include('violation 1', 'violation 2')
        end

        it 'attaches the last_updated_date as a paragraph to the disclosure array' do
          expect(subject.disclosure_attributes).to include('Last Updated: 06/27/2017')
        end
      end
    end

    describe '#dangerous building headers' do
      let (:source_link) { "<a href='#{KcmoDatasets::DangerousBuildings::SOURCE_URI}'><small>(Source)</small></a>" }

      context 'when dangerous building data is not available' do
        it 'does not add any three eleven headers to the disclosure attributes' do
          expect(subject.disclosure_attributes).to_not include(
            'violation 1', 
            'violation 2',
            'Last Updated: 06/27/2017',
            "<h2 class='info-window-header'>Dangerous Building</h2>&nbsp;#{source_link}"
          )
        end
      end

      context 'when dangerous building data is available' do
        before do
          subject.instance_variable_set(:@dangerous_buildings, {
            statusofcase: 'dangerous',
            last_updated_date: '06/28/2017'
          })
        end

        it 'includes a source link to the dangerous building data set' do
          expect(subject.disclosure_attributes).to include(
            "<h2 class='info-window-header'>Dangerous Building</h2>&nbsp;#{source_link}"
          )
        end

        it 'attaches a paragraph for the status of the building' do
          expect(subject.disclosure_attributes).to include('dangerous')
        end

        it 'attaches the last_updated_date as a paragraph to the disclosure array' do
          expect(subject.disclosure_attributes).to include('Last Updated: 06/28/2017')
        end
      end
    end

    describe '#vacant registry failure headers' do
      let (:source_link) { "<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'><small>(Source)</small></a>" }

      context 'when vacant registry violation data is not available' do
        it 'does not add any three eleven headers to the disclosure attributes' do
          expect(subject.disclosure_attributes).to_not include(
            "<h2 class='info-window-header'>Property Violations</h2>&nbsp;#{source_link}", 
            'Last Updated: 06/30/2017',
            'vacant registration failure'
          )
        end
      end

      context 'when vacant registry violation data is available' do
        before do
          subject.instance_variable_set(:@vacant_registry_failure_data, {
            violation_description: 'vacant registration failure',
            last_updated_date: '06/30/2017'
          })
        end

        it 'includes a source link to the dangerous building data set' do
          expect(subject.disclosure_attributes).to include(
            "<h2 class='info-window-header'>Property Violations</h2>&nbsp;#{source_link}"
          )
        end

        it 'attaches a paragraph for the status of the building' do
          expect(subject.disclosure_attributes).to include('vacant registration failure')
        end

        it 'attaches the last_updated_date as a paragraph to the disclosure array' do
          expect(subject.disclosure_attributes).to include('Last Updated: 06/30/2017')
        end
      end
    end

    describe '#tax delinquent disclosure attributes' do
      context 'when tax delinquent data is not available' do
        it 'does not add any three eleven headers to the disclosure attributes' do
          expect(subject.disclosure_attributes).to_not include(
            '9 year(s) Tax Delinquent', 
            'Last Updated: 06/27/2017',
            "<h2 class='info-window-header'>Tax Delinquency</h2>&nbsp;<a href='http://data.org'><small>(Source)</small></a>"
          )
        end
      end

      context 'when tax delinquent data is available' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, {
            source: 'http://data.org',
            consecutive_years: '9'
          })
        end

        it 'includes a source link to the dangerous building data set' do
          expect(subject.disclosure_attributes).to include('9 year(s) Tax Delinquent')
        end

        it 'attaches a paragraph for the status of the building' do
          expect(subject.disclosure_attributes).to include(
            "<h2 class='info-window-header'>Tax Delinquency</h2>&nbsp;<a href='http://data.org'><small>(Source)</small></a>"
          )
        end
      end
    end

    describe '#code violation count attributes' do
      let (:source_link) { "<a href='#{KcmoDatasets::DangerousBuildings::SOURCE_URI}'><small>(Source)</small></a>" }

      context 'when tax delinquent data is not available' do
        it 'does not add any three eleven headers to the disclosure attributes' do
          expect(subject.disclosure_attributes).to_not include(
            "<h2 class='info-window-header'>Code Violation Count</h2>&nbsp;#{source_link}",
            '9 Code Violations',
          )
        end
      end

      context 'when tax delinquent data is available' do
        before do
          subject.instance_variable_set(:@address_violation_count, {
            source: 'http://data.org',
            violation_count: '9'
          })
        end

        it 'includes a source link to the dangerous building data set' do
          expect(subject.disclosure_attributes).to include('9 Code Violations')
        end

        it 'attaches a paragraph for the status of the building' do
          expect(subject.disclosure_attributes).to include(
            "<h2 class='info-window-header'>Code Violation Count</h2>&nbsp;#{source_link}"
          )
        end
      end
    end
  end

  describe '#legally_abandoned?' do
    before do
      subject.instance_variable_set(:@address_violation_count, {'data' => ['data']})
      subject.instance_variable_set(:@tax_delinquent_data, {'data' => ['data']})
      subject.instance_variable_set(:@vacant_registry_failure_data, {'data' => ['data']})
      subject.instance_variable_set(:@dangerous_buildings, {'data' => ['data']})
      subject.instance_variable_set(:@three_eleven_data, {'data' => ['data']})

      allow(subject).to receive(:total_points).and_return(4)
    end

    context 'when address violation data is absent' do
      before do
        subject.instance_variable_set(:@address_violation_count, nil)
      end

      it 'returns false' do
        expect(subject.legally_abandoned?).to eq(false)
      end
    end

    context 'when tax delinquent data is absent' do
      before do
        subject.instance_variable_set(:@tax_delinquent_data, nil)
      end

      it 'returns false' do
        expect(subject.legally_abandoned?).to eq(false)
      end
    end

    context 'when total points is less than 4' do
      before do
        allow(subject).to receive(:total_points).and_return(2)
      end

      it 'returns false' do
        expect(subject.legally_abandoned?).to eq(false)
      end
    end

    context 'when tax delinquent data, address violation count data, and the total points are at least 4' do
      context 'when vacant registry failure data is present' do
        before do
          subject.instance_variable_set(:@dangerous_buildings, nil)
          subject.instance_variable_set(:@three_eleven_data, nil)
        end

        it 'returns false' do
          expect(subject.legally_abandoned?).to eq(true)
        end
      end

      context 'when dangerous building data is present' do
        before do
          subject.instance_variable_set(:@vacant_registry_failure_data, nil)
          subject.instance_variable_set(:@three_eleven_data, nil)
        end

        it 'returns true' do
          expect(subject.legally_abandoned?).to eq(true)
        end
      end

      context 'when three eleven data is present' do
        before do
          subject.instance_variable_set(:@vacant_registry_failure_data, nil)
          subject.instance_variable_set(:@dangerous_buildings, nil)
        end

        it 'returns true' do
          expect(subject.legally_abandoned?).to eq(true)
        end
      end

      context 'when none of these are present' do
        before do
          subject.instance_variable_set(:@vacant_registry_failure_data, nil)
          subject.instance_variable_set(:@dangerous_buildings, nil)
          subject.instance_variable_set(:@three_eleven_data, nil)
        end

        it 'returns false' do
          expect(subject.legally_abandoned?).to eq(false)
        end
      end
    end
  end

  describe '#total_points' do
    context 'when no data is set on the item' do
      it 'returns 0' do
        expect(subject.total_points).to eq(0)
      end
    end

    context 'when dangerous buildings data is present' do
      before do
        subject.instance_variable_set(:@dangerous_buildings, {data: 'present'})
      end

      it 'adds 2 points to the total' do
        expect(subject.total_points).to eq(2)
      end
    end

    context 'when vacant registry failure data is present' do
      before do
        subject.instance_variable_set(:@vacant_registry_failure_data, {data: 'present'})
      end

      it 'adds 2 points to the total' do
        expect(subject.total_points).to eq(2)
      end
    end

    context 'when three eleven is present' do
      context 'when the violations array is empty' do
        before do
          subject.instance_variable_set(:@three_eleven_data, {violations: []})
        end

        it 'adds 0 points to the total' do
          expect(subject.total_points).to eq(0)
        end
      end

      context 'when the violations array length is at least 1' do
        before do
          subject.instance_variable_set(:@three_eleven_data, {violations: ['violation 1', 'violation 2']})
        end

        it 'adds 2 points to the total' do
          expect(subject.total_points).to eq(2)
        end
      end
    end

    context 'when tax delinquent data is present' do
      context 'when consective_years is not present' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, nil)
        end

        it 'adds 0 points to the total' do
          expect(subject.total_points).to eq(0)
        end
      end

      context 'when consective_years is 0' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, {consecutive_years: 0})
        end

        it 'adds 0 points to the total' do
          expect(subject.total_points).to eq(0)
        end
      end

      context 'when consective_years is between 1 and 3' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, {consecutive_years: 2})
        end

        it 'adds 1 points to the total' do
          expect(subject.total_points).to eq(1)
        end
      end

      context 'when consective_years is greater than or equal to 3' do
        before do
          subject.instance_variable_set(:@tax_delinquent_data, {consecutive_years: 3})
        end

        it 'adds 2 points to the total' do
          expect(subject.total_points).to eq(2)
        end
      end
    end

    context 'when address violation count data is present' do
      context 'when violation_count is not present' do
        before do
          subject.instance_variable_set(:@address_violation_count, nil)
        end

        it 'adds 0 points to the total' do
          expect(subject.total_points).to eq(0)
        end
      end

      context 'when violation_count is 0' do
        before do
          subject.instance_variable_set(:@address_violation_count, {violation_count: 0})
        end

        it 'adds 0 points to the total' do
          expect(subject.total_points).to eq(0)
        end
      end

      context 'when violation_count is between 1 and 3' do
        before do
          subject.instance_variable_set(:@address_violation_count, {violation_count: 2})
        end

        it 'adds 1 points to the total' do
          expect(subject.total_points).to eq(1)
        end
      end

      context 'when violation_count is greater than or equal to 3' do
        before do
          subject.instance_variable_set(:@address_violation_count, {violation_count: 3})
        end

        it 'adds 2 points to the total' do
          expect(subject.total_points).to eq(2)
        end
      end
    end
  end
end
