require "rails_helper"

RSpec.describe Api::Neighborhood::VacanciesController, :type => :controller do
  let(:neighborhood) { double(id: 24) }

  before do
    allow(Neighborhood).to receive(:find)
      .with(neighborhood.id.to_s)
      .and_return(neighborhood)
  end

  describe "GET legally_abandoned" do
    let(:vacancy_data) { double }
    let(:legally_abandoned_data) { {'24' => [] }.to_json }

    before do
      allow(neighborhood).to receive(:vacancy_data)
        .and_return(vacancy_data)

      allow(vacancy_data).to receive(:legally_abandoned)
        .and_return(legally_abandoned_data)
    end

    it 'gets the legally abandoned data for the given neighborhood' do
      get :legally_abandoned, id: neighborhood.id
      expect(response.body).to eq(legally_abandoned_data)
    end
  end
end