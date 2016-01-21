class NeighborhoodsController < ApplicationController
  def index
    @neighborhood =
      ::Neighborhood.includes(:coordinates).search_by_name(params[:search]).first ||
      ::Neighborhood.includes(:coordinates).find_by!(name: Neighborhood::Search.search(params[:search]))
  end

  def show
    @neighborhood = ::Neighborhood.find(params[:id])
  end
end

