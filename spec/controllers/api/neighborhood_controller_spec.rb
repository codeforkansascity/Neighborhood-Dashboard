require "rails_helper"

RSpec.describe Api::NeighborhoodController, :type => :controller do
  render_views true

  describe '#show' do
    let(:neighborhood) { double(id: 5, name: 'Test', coordinates: ['Jake', 'John']) }

    before do
      allow(Neighborhood).to receive(:includes).and_return(neighborhood)
      allow(neighborhood).to receive(:find).and_return(neighborhood)
    end

    it 'finds the correct neighborhood' do
      get :show, id: 5

      json_response = JSON.parse(response.body)

      expect(json_response["id"]).to eq(5)
      expect(json_response["name"]).to eq('Test')
      expect(json_response["coordinates"]).to eq(['Jake', 'John'])
    end
  end

  describe '#search' do
    subject do 
      get :search, search_neighborhood: 'Qua'
      JSON.parse(response.body)
    end

    let(:neighborhoods) {
      [
        double(id: 1, name: 'Test 1'),
        double(id: 2, name: 'Test 2'),
        double(id: 3, name: 'Test 3')
      ]
    }

    before do
      allow(Neighborhood).to receive(:find_by_fuzzy_name).and_return(neighborhoods)
    end

    it 'returns all the neighborhoods corresponding to the query' do
      expect(subject.size).to eq(3)

      expect(subject.find { |hood| hood["id"] == 1 }["name"]).to eq('Test 1')
      expect(subject.find { |hood| hood["id"] == 2 }["name"]).to eq('Test 2')
      expect(subject.find { |hood| hood["id"] == 3 }["name"]).to eq('Test 3')
    end
  end

  describe '#locate' do
    subject do 
      get :locate, search_address: 'Addre'
      JSON.parse(response.body)
    end

    let(:neighborhood) { double(id: 5, name: 'Test', coordinates: ['Jake', 'John']) }
    let(:neighborhood_search) { double }

    before do
      allow(NeighborhoodServices::Search).to receive(:search).and_return(neighborhood_search)
      allow(Neighborhood).to receive(:includes).and_return(neighborhood)
      allow(neighborhood).to receive(:find_by!).and_return(neighborhood)
    end

    it 'sets up the query appropriately' do
      subject
      expect(NeighborhoodServices::Search).to have_received(:search).with('Addre')
      expect(Neighborhood).to have_received(:includes).with(:coordinates)
      expect(neighborhood).to have_received(:find_by!).with(name: neighborhood_search)
    end

    it 'finds the correct neighborhood' do
      subject
      expect(subject["id"]).to eq(5)
      expect(subject["name"]).to eq('Test')
      expect(subject["coordinates"]).to eq(['Jake', 'John'])
    end
  end
end
