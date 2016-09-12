class Api::Neighborhood::CrimeController < ApplicationController
  def index
    neighborhood = ::Neighborhood.find(params[:id])
    render json: NeighborhoodServices::Crime.new(neighborhood, params).mapped_coordinates
  end

  def grouped_totals
    neighborhood = ::Neighborhood.find(params[:id])
    render json: NeighborhoodServices::Crime.new(neighborhood, params).grouped_totals
  end
end
