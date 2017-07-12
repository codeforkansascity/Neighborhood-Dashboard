require 'google_maps/static_generator'

class VacancyPdfExport
  attr_accessor :data_points

  delegate :name, to: :neighborhood

  ALPHANUMERIC_CHARS = ("1".."9").map{ |number| number } + ("A".."Z").map{|letter| letter}
  COLORS = ["6B2C00", "004200", "3C0042", "423000", "010042", "18181B", "422412", "6B0000"]

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
        label: ALPHANUMERIC_CHARS[(i) % ALPHANUMERIC_CHARS.size],
        color: COLORS[((i) / ALPHANUMERIC_CHARS.size) % COLORS.size],
        data: data
      }
    end
  end

  private
  
  attr_accessor :neighborhood
end