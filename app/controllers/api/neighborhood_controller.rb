class Api::NeighborhoodController < ApplicationController
  def index
    @neighborhood =
      ::Neighborhood.includes(:coordinates).search_by_name(params[:search_neighborhood]).first ||
      ::Neighborhood.includes(:coordinates).find_by!(name: Neighborhood::Search.search(params[:search_address]))
  end

  def show
    @neighborhood = ::Neighborhood.find(params[:id])
  end
end
