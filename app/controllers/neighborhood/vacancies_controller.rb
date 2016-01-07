class Neighborhood::VacanciesController < ApplicationController
  def dangerous_buildings
    render json: Neighborhood.find(params[:id]).vacancy_data.dangerous_buildings
  end
end
