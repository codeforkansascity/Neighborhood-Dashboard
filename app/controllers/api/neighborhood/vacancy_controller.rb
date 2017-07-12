class Api::Neighborhood::VacancyController < ApplicationController
  def index
    neighborhood = ::Neighborhood.find(params[:id])

    if params[:filters] && params[:filters].include?('all_abandoned')
      data = NeighborhoodServices::LegallyAbandonedCalculation.new(neighborhood).vacant_indicators
    else
      data = NeighborhoodServices::FilteredVacantData.new(neighborhood).filtered_vacant_data(params)
    end

    respond_to do |format|
      format.pdf do
        render pdf: neighborhood.name, 
               template: 'pdf/vacancy_export.html.erb', 
               locals: {
                 pdf_generator: VacancyPdfExport.new(neighborhood, data.flatten)
               }
      end

      format.any(:json) { render json: data.flatten.map(&:to_h) }
    end
  end
end
