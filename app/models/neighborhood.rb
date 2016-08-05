class Neighborhood < ActiveRecord::Base
  scope :search_by_name, -> (name) { where("name LIKE ?", name) }

  has_many :registered_vacant_lots

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  has_and_belongs_to_many :coordinates
  accepts_nested_attributes_for :coordinates

  def addresses
    return @addresses if @addresses.present?

    uri = URI::escape("http://api.codeforkc.org//address-by-neighborhood/V0/#{name}?city=&state=mo")
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

  def filtered_vacant_data(filters)
    data = 
      NeighborhoodServices::VacancyData::LandBank.new(self, filters).data + 
      NeighborhoodServices::VacancyData::ThreeEleven.new(self, filters).data +
      NeighborhoodServices::VacancyData::PropertyViolations.new(self, filters).data +
      NeighborhoodServices::VacancyData::DangerousBuildings.new(self, filters).data

    if filters['filters'].include?('registered_vacant')
      data += NeighborhoodServices::VacancyData::VacantLotRegistry.new(self,filters).data
    end

    if filters['filters'].include?('dangerous_building')
      data += NeighborhoodServices::VacancyData::DangerousBuildings.new(self, filters).data
    end

    data
  end
end
