RSpec.describe Entities::ThreeEleven::Sidewalk do
  subject{ Entities::ThreeEleven::Sidewalk.deserialize(data_hash) }

  let(:data_hash) {
    {
      street_address: 'address',
      creation_date: '2017-07-12',
      case_id: '5',
      request_type: 'sidewalk',
      zip_code: '54124',
      address_with_geocode: {
        coordinates: [10, 10]
      }
    }
  }

  let(:metadata) { {'viewLastModified' => 1433307658} }

  describe '#disclosure_attributes' do
    it 'contains the case id' do
      expect(subject.disclosure_attributes).to include('<b>Case ID: </b>5')
    end

    it 'contains the request type' do
      expect(subject.disclosure_attributes).to include('sidewalk')
    end

    context 'when the address is not provided' do
      let(:data_hash) { {} }

      it 'shows a blank spot on the address' do
        expect(subject.disclosure_attributes).to include('<b>Address:</b>&nbsp;N/A')
      end
    end

    context 'when the address is provided' do
      it 'adds the address titleized to the disclosure array' do
        expect(subject.disclosure_attributes).to include('<b>Address:</b>&nbsp;Address')
      end
    end

    context 'when metadata is not provided' do
      it 'adds N/A to the disclosure attributes array' do
        expect(subject.disclosure_attributes).to include('Last Updated Date: N/A')
      end
    end

    context 'when metadata is provided' do
      before do
        subject.metadata = metadata
      end

      it 'adds N/A to the disclosure attributes array' do
        expect(subject.disclosure_attributes).to include('Last Updated Date: 06/03/2015')
      end
    end

    context 'when the creation date is not provided' do
      let(:data_hash) { {} }

      it 'adds N/A to the disclosure attributes array' do
        expect(subject.disclosure_attributes).to include('<b>Created: </b>N/A')
      end
    end

    context 'when the creation date is provided' do
      it 'adds N/A to the disclosure attributes array' do
        expect(subject.disclosure_attributes).to include('<b>Created: </b>07/12/2017')
      end
    end
  end
end
