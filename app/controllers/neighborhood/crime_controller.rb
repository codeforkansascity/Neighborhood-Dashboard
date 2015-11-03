class Neighborhood::CrimeController < ApplicationController
  def index
    render json: Neighborhood.find(params[:neighborhood_id]).map_coordinates(params[:crime_codes])
  end
end
