class Api::Neighborhood::VacancyController < ApplicationController
  def index
    if params[:filters].include?('all_abandoned')
      data = [NeighborhoodServices::LegallyAbandonedCalculation.new(::Neighborhood.find(params[:id])).vacant_indicators]
    else
      data = [NeighborhoodServices::FilteredVacantData.new(params[:id]).filtered_vacant_data(params)]
    end

    render json: data.flatten
  end
end
