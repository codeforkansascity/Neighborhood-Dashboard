class HomeController < ApplicationController
  def index
    @neighborhoods = Neighborhood.all
  end
end
