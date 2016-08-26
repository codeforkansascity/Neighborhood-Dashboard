class Api::Neighborhood::CensusDataController < ApplicationController
  def index
    render json: NeighborhoodServices::CensusData.new(params[:id]).fetch_data
  end
end
