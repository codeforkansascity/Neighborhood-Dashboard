require 'rails_helper'

RSpec.describe Api::Neighborhood::MiscellaneousDataController, :type => :controller do
  let(:neighborhood) { double(id: 10, name: 'test') }
  let(:filtered_data) { 
    [
      double(to_h: {title: 'data-one'}),
      double(to_h: {title: 'data-two'}),
      double(to_h: {title: 'data-three'})
    ]
  }

  before do
    allow(Neighborhood).to receive(:find).with(neighborhood.id.to_s).and_return(neighborhood)

    allow(NeighborhoodServices::MiscellaneousData).to receive(:new)
      .with(neighborhood)
      .and_return(neighborhood)

    allow(neighborhood).to receive(:filtered_data).and_return(filtered_data)
    allow(controller).to receive(:render)
  end

  describe '#index' do
    it 'renders json returned from miscellaneous data' do
      get :index, id: neighborhood.id, filters: ['information'], format: :json
      expect(controller).to have_received(:render).with(json: filtered_data.map(&:to_h))
    end
  end
end
