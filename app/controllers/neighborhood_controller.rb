class NeighborhoodController < ApplicationController
  def index
    @neighborhood = Neighborhood.find_by!(name: NeighborhoodSearch.search(params[:search]))
    @neighborhood_data = Neighborhood311DataParser.new(
      HTTParty.get(
        URI::escape("https://data.kcmo.org/resource/7at3-sxhp.json?neighborhood=#{@neighborhood.name}")
      )
    )
  end

  def show
    @neighborhood = Neighborhood.find(params[:id])
    @neighborhood_data = NeighborhoodDataParser.new(
      HTTParty.get(
        URI::escape("https://data.kcmo.org/resource/7at3-sxhp.json?neighborhood=#{@neighborhood.name}")
      )
    )

    render 'index'
  end
end

