class NeighborhoodController < ApplicationController
  def index
    @neighborhood = Neighborhood.find_by!(name: Neighborhood::Search.search(params[:search]))
  end

  def show
    @neighborhood = Neighborhood.find(params[:id])
    
    render 'index'
  end
end

