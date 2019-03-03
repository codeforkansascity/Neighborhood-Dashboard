require 'google_maps/static_generator'

class VacancyPdfExport
  attr_accessor :data_points

  delegate :name, to: :neighborhood

  def initialize(neighborhood, data_points = [])
    @neighborhood = neighborhood
    @data_points = data_points
  end

  def google_maps_uri
    GoogleMaps::StaticGenerator.new(@neighborhood, markers).generate_static_api_uri
  end

  def markers
    @markers ||= @data_points.each_with_index.map do |data, i|
      {
        label: i + 1,
        color: "000000",
        data: data
      }
    end
  end

  private
  
  attr_accessor :neighborhood
end