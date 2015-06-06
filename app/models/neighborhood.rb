class Neighborhood < ActiveRecord::Base  
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  geocoded_by :address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  def name
    geocoded_information = Geocoder.search([latitude, longitude]).first

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
