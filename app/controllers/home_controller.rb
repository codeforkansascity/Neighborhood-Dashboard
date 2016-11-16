class HomeController < ApplicationController
  def index
    render file: 'layouts/application.html.erb'
  end
end
