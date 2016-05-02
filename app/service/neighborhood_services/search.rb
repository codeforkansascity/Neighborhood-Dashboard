class Neighborhood::Search
  def self.search(search)
    geocoded_information = Geocoder.search(search).first

    if geocoded_information.present?
      geocoded_data = geocoded_information.data
    end

    if geocoded_data.present?
      address_components = geocoded_data['address_components']
    end

    if address_components.present?
      geocoded_neighborhood = address_components.find { |component| component["types"].include?('neighborhood') }
    end

    geocoded_neighborhood['long_name'] if geocoded_neighborhood.present?
  end
end