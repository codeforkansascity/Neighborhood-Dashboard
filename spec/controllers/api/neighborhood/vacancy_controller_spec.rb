require "rails_helper"

RSpec.describe Api::Neighborhood::VacancyController, :type => :controller do
  let(:neighborhood) { double(id: 10, name: 'test') }
  let(:legally_abandoned_data) { [double(to_h: {data: 10}), double(to_h: {data: 10})]}
  let(:filtered_vacant_data) { [double(to_h: {data: 20}), double(to_h: {data: 20})]}
  let(:vacancy_pdf_export) { double }

  before do
    allow(Neighborhood).to receive(:find).with(neighborhood.id.to_s).and_return(neighborhood)

    allow(NeighborhoodServices::LegallyAbandonedCalculation).to receive(:new)
      .with(neighborhood)
      .and_return(neighborhood)

    allow(NeighborhoodServices::FilteredVacantData).to receive(:new)
      .with(neighborhood)
      .and_return(neighborhood)    

    allow(neighborhood).to receive(:vacant_indicators).and_return(legally_abandoned_data)
    allow(neighborhood).to receive(:filtered_vacant_data).and_return(filtered_vacant_data)
    allow(controller).to receive(:render)
  end

  describe '#index' do
    context 'when a pdf is exported' do
      context 'when the filters contain all_abandoned' do
        before do
          allow(VacancyPdfExport).to receive(:new)
            .with(neighborhood, legally_abandoned_data)
            .and_return(vacancy_pdf_export)
        end

        it 'returns all the legally abandoned data as a pdf' do
          get :index, id: neighborhood.id, format: :pdf, filters: ['all_abandoned']

          expect(controller).to have_received(:render).with(
            pdf: neighborhood.name,
            template: 'pdf/vacancy_export.html.erb', 
            locals: { pdf_generator: vacancy_pdf_export}
          )
        end
      end

      context 'when the filters contain all_abandoned' do
        before do
          allow(VacancyPdfExport).to receive(:new)
            .with(neighborhood, filtered_vacant_data)
            .and_return(vacancy_pdf_export)
        end

        it 'returns all the filtered vacant data as a pdf' do
          get :index, id: neighborhood.id, format: :pdf, filters: ['']

          expect(controller).to have_received(:render).with(
            pdf: neighborhood.name,
            template: 'pdf/vacancy_export.html.erb', 
            locals: { pdf_generator: vacancy_pdf_export}
          )
        end
      end
    end

    context 'when json is requested' do
      context 'when the filters contain all_abandoned' do
        it 'returns all the legally abandoned data' do
          get :index, id: neighborhood.id, format: :json, filters: ['all_abandoned']
          expect(controller).to have_received(:render).with(json: legally_abandoned_data.map(&:to_h))
        end
      end

      context 'when the filters do not contain all_abandoned' do
        it 'returns the requested filtered vacancy data' do
          get :index, id: neighborhood.id, format: :json, filters: ['']
          expect(controller).to have_received(:render).with(json: filtered_vacant_data.map(&:to_h))
        end
      end
    end
  end
end