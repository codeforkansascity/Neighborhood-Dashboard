class NeighborhoodDataParser
  def initialize(data)
    @data = data
  end

  def yearly_311
    yearly_311_data = {}

    @data.sort { |element| element['creation_year'].to_i }
    @data.each do |data|
      if data['creation_year'].present?
        if yearly_311_data[data['creation_year']].nil?
          yearly_311_data[data['creation_year']] = 1
        else
          yearly_311_data[data['creation_year']] = yearly_311_data[data['creation_year']] + 1
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