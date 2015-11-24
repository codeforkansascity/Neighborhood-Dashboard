class Neighborhood::CrimeController < ApplicationController
  def index
    render json: Neighborhood.find(params[:id]).crime_data.map_coordinates(params[:crime_codes])
  end
end
