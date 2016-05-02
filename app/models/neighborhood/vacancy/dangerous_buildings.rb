class Neighborhood::Vacancy::DangerousBuildings
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def data
    request_url = URI::escape("https://data.kcmo.org/resource/w6zu-4g2q.json?$where=neighborhood = '#{@neighborhood.name}'")
    @properties = HTTParty.get(request_url, verify: false))
  end

  def dangerous_buildings
    request_url = URI::escape("https://data.kcmo.org/resource/w6zu-4g2q.json?$where=neighborhood = '#{@neighborhood.name}'")
    
    @properties = HTTParty.get(request_url, verify: false))
  end

  def tooltip_properties

  end

  def mapify_coordinates

  end
end