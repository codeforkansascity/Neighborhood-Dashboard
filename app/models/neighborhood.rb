class Neighborhood < ActiveRecord::Base
  scope :search_by_name, -> (name) { where("name LIKE ?", name) }

  has_many :registered_vacant_lots

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  has_and_belongs_to_many :coordinates
  accepts_nested_attributes_for :coordinates

  fuzzily_searchable :name

  def addresses
    return @addresses if @addresses.present?

    uri = address_source_uri
    puts "Querying #{uri}"
    address_data = JSON.parse(HTTParty.get(uri))
    @addresses = address_data['data'] || []
  rescue
    @addresses = []
  end

  def address_source_uri
    URI::escape("http://dev-api.codeforkc.org/address-by-neighborhood/V0/#{name}?city=Kansas City&state=MO")
  end

  def within_polygon_query(location_attribute)
    neighborhood_coordinates = coordinates.map{ |neighborhood|
      "#{neighborhood.longtitude} #{neighborhood.latitude}"
    }.join(',')

    "within_polygon(#{location_attribute}, 'MULTIPOLYGON (((#{neighborhood_coordinates})))')"
  end

  def center
    if coordinates.present?
      coordinates.each_with_object({longtitude: 0, latitude: 0}) do |coordinate, hash|
        hash[:longtitude] += coordinate.longtitude / coordinates.size.to_f
        hash[:latitude] += coordinate.latitude / coordinates.size.to_f
      end
    else
      {}
    end
  end
end
