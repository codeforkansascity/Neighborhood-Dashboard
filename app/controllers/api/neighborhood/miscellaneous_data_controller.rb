class Api::Neighborhood::MiscellaneousDataController < ApplicationController
  def index
    neighborhood = ::Neighborhood.find(params[:id])
    render json: NeighborhoodServices::MiscellaneousData.new(neighborhood).filtered_data(params).map(&:to_h)
  end
end
