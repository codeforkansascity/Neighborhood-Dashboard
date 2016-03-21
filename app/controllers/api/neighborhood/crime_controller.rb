class Api::Neighborhood::CrimeController < ApplicationController
  def index
    render json: ::Neighborhood.find(params[:id]).crime_data.map_coordinates(params)
  end

  def grouped_totals
    render json: ::Neighborhood.find(params[:id]).crime_data.grouped_totals
  end
end
