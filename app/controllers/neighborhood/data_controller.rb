class Neighborhood::DataController < ApplicationController
  def trending_crime
    render json: Neighborhood.find(params[:id]).crime_data.yearly_counts
  end

  def trending_three_eleven
    render json: Neighborhood.find(params[:id]).three_eleven_data
  end
end
