class Api::NeighborhoodController < ApplicationController
  def index
    @neighborhoods = ::Neighborhood.includes(:coordinates).all
  end

  def show
    @neighborhood = ::Neighborhood.includes(:coordinates).find(params[:id])
  end

  def search
    @neighborhoods = ::Neighborhood.find_by_fuzzy_name(params[:search_neighborhood])
  end

  def locate
    @neighborhood = ::Neighborhood.includes(:coordinates).find_by!(name: NeighborhoodServices::Search.search(params[:search_address]))
    render 'show'
  end

end
