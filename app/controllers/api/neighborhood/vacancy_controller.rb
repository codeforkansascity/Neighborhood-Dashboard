class Api::Neighborhood::VacancyController < ApplicationController
  def dangerous_buildings
    render json: ::Neighborhood.find(params[:id]).vacancy_data.dangerous_buildings
  end

  def vacant_lots
    render json: ::Neighborhood.find(params[:id]).vacancy_data.vacant_lots
  end

  def legally_abandoned
    render json: ::Neighborhood.find(params[:id]).vacancy_data.legally_abandoned
  end

  def index
    render json: ::Neighborhood.find(params[:id]).filtered_vacant_data(params)
  end
end