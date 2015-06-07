class NeighborhoodController < ApplicationController
  def index
    @neighborhood = Neighborhood.find_by!(name: NeighborhoodSearch.search(params[:search]))
  end

  def show
  end
end
