class Neighborhood < ActiveRecord::Base
  scope :search_by_name, -> (name) { where("name LIKE ?", name) }

  has_many :registered_vacant_lots

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  has_and_belongs_to_many :coordinates
  accepts_nested_attributes_for :coordinates

  def addresses
    return @addresses if @addresses.present?

    uri = URI::escape("http://dev-api.codeforkc.org//address-by-neighborhood/V0/#{name}?city=&state=mo")
    @addresses = JSON.parse(HTTParty.get(uri))
  rescue
    @addresses = {}
  end

  def three_eleven_data
    Neighborhood::ThreeElevenData.new(self).data
  end

  def crime_data
    Neighborhood::CrimeData.new(self)
  end

  def vacancy_data
    Neighborhood::VacancyData.new(self)
  end

  def within_polygon_query(location_attribute)
    neighborhood_coordinates = coordinates.map{ |neighborhood|
      "#{neighborhood.longtitude} #{neighborhood.latitude}"
    }.join(',')

    "within_polygon(#{location_attribute}, 'MULTIPOLYGON (((#{neighborhood_coordinates})))')"
  end

  def filtered_vacant_data(filters)
    filters_copy = filters.dup

    if filters_copy['filters'].include?('all_abandoned')
      filters_copy['filters'] += NeighborhoodServices::VacancyData::LandBank::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::ThreeEleven::POSSIBLE_FILTERS
      filters_copy['filters'] += NeighborhoodServices::VacancyData::PropertyViolations::POSSIBLE_FILTERS
      filters_copy['filters'] += ['registered_vacant','dangerous_building']
    end

    data =
      NeighborhoodServices::VacancyData::LandBank.new(self, filters_copy).data + 
      NeighborhoodServices::VacancyData::ThreeEleven.new(self, filters_copy).data +
      NeighborhoodServices::VacancyData::PropertyViolations.new(self, filters_copy).data

    if filters_copy['filters'].include?('registered_vacant')
      data += NeighborhoodServices::VacancyData::VacantLotRegistry.new(self,filters_copy).data
    end

    if filters_copy['filters'].include?('dangerous_building')
      data += NeighborhoodServices::VacancyData::DangerousBuildings.new(self, filters_copy).data
    end

    data
  end
end
