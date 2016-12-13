require 'census_data/neighborhood_data'

class Api::Neighborhood::CensusDataController < ApplicationController
  def index
    render json: CensusData::NeighborhoodData.new(Neighborhood.find(params[:id])).fetch_data
  end
end
