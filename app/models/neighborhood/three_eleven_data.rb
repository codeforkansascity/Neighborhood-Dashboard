class Neighborhood::ThreeElevenData
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def data
    service_url = URI::escape("https://data.kcmo.org/resource/7at3-sxhp.json?neighborhood=#{@neighborhood.name}")
    response = HTTParty.get(service_url)

    yearly_311_data = {}

    response.sort! { |element| element['creation_year'].to_i }

    response.each do |element|
      if element['creation_year'].present?
        if yearly_311_data[element['creation_year']].nil?
          yearly_311_data[element['creation_year']] = 1
        else
          yearly_311_data[element['creation_year']] = yearly_311_data[element['creation_year']] + 1
        end
      end
    end

    temp_data = yearly_311_data.sort
    
    returned_hash = {}

    temp_data.each { |item|
      returned_hash[item[0]] = item[1]
    }

    returned_hash
  end
end
