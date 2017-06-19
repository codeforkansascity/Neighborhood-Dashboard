RSpec.describe Entities::Crime do
  subject { Entities::Crime.deserialize(data_hash)}

  let(:data_hash) { 
    {
      ibrs: '13A',
      type: 'Feature', 
      description: 'Description',
      address: 'Address',
      from_date: '2014-11-01T00:00:00.000',
      dataset_year: '2014', 
      source: 'www.source.org', 
      last_updated: '2014-11-01T00:00:00.000', 
      location_1: {
        "type" => 'Point',
        "coordinates" => [
          -94.59213408799997, 
          39.103791030000025
        ]
      }
    } 
  }

  describe '#properties' do
    describe '#color' do
      context 'when the crime is of type PERSON' do
        before do
          data_hash[:ibrs] = '11C'
        end

        it 'sets the marker color to the color indicating person crime' do
          expect(subject.properties[:color]).to eq('#626AB2')
        end
      end

      context 'when the crime is of type PROPERTY' do
        before do
          data_hash[:ibrs] = '26E'
        end

        it 'sets the marker color to the color indicating property crime' do
          expect(subject.properties[:color]).to eq('#313945')
        end
      end

      context 'when the crime is of type SOCIETY' do
        before do
          data_hash[:ibrs] = '90B'
        end

        it 'sets the marker color to the color indicating society crime' do
          expect(subject.properties[:color]).to eq('#6B7D96')
        end
      end

      context 'when the crime does not fit a category' do
        before do
          data_hash[:ibrs] = 'Blank'
        end

        it 'sets the marker color to the color indicating category other' do
          expect(subject.properties[:color]).to eq('#ffffff')
        end
      end
    end
  end

  describe '#diclosure_attributes' do
    let(:disclosure_attributes) { subject.disclosure_attributes }

    it 'adds the description to the disclosure attributes' do
      expect(disclosure_attributes).to include(data_hash[:description])
    end

    it 'adds the description to the disclosure attributes' do
      expect(disclosure_attributes).to include(data_hash[:description])
    end

    it 'adds the address to the disclosure attributes' do
      expect(disclosure_attributes).to include(data_hash[:address].titleize)
    end

    context 'when the from_date is parsable' do
      it 'adds the from_date to the disclosure_attributes' do
        expect(disclosure_attributes).to include("Committed on #{DateTime.parse(data_hash[:from_date]).strftime('%m/%d/%Y')}")
      end
    end

    context 'when the from_date is not parsable' do
      before do
        data_hash[:from_date] = 'Bad Date'
      end

      it 'adds the dataset year to the disclosure_attributes' do
        expect(disclosure_attributes).to include("Committed in #{data_hash[:dataset_year]}")
      end
    end

    context 'when the last updated date is parsable' do
      it 'adds the last updated date to the disclosure attributes' do
        expect(disclosure_attributes).to include("Last Updated: #{DateTime.strptime(data_hash[:last_updated].to_s, '%s').strftime('%m/%d/%Y')}")
      end
    end

    context 'when the last updated date is parsable' do
      before do
        data_hash[:last_updated] = 'Non parsable'
      end

      it 'adds the last updated date to the disclosure attributes' do
        expect(disclosure_attributes).to include('Last Updated: N/A')
      end
    end
  end

  describe '#properties' do
    it 'sets all the attributes for all instance variables that appear in the hash' do
      expect(subject.ibrs).to eq(data_hash[:ibrs])
      expect(subject.type).to eq(data_hash[:type])
      expect(subject.description).to eq(data_hash[:description])
      expect(subject.address).to eq(data_hash[:address])
      expect(subject.from_date).to eq(data_hash[:from_date])
      expect(subject.dataset_year).to eq(data_hash[:dataset_year])
      expect(subject.source).to eq(data_hash[:source])
      expect(subject.last_updated).to eq(data_hash[:last_updated])
      expect(subject.location_1).to eq(data_hash[:location_1])
    end
  end

  describe '#mappable' do
    context 'when the coordinates exist on location_1' do
      it 'sets the item as mappable' do
        expect(subject.mappable?).to eq(true)
      end
    end

    context 'when location_1 does not contain coordinates' do
      before do
        data_hash[:location_1] = {"type" => 'point'}
      end

      it 'sets the item as non mappable' do
        expect(subject.mappable?).to eq(false)
      end
    end
  end
end
