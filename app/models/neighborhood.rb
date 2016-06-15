class Neighborhood < ActiveRecord::Base
  scope :search_by_name, -> (name) { where("name LIKE ?", name) }

  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  has_and_belongs_to_many :coordinates
  accepts_nested_attributes_for :coordinates

  def addresses
    uri = URI::escape("http://api.codeforkc.org//address-by-neighborhood/V0/#{name}?city=&state=mo")
    JSON.parse(HTTParty.get(uri))
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
    NeighborhoodServices::VacancyData::LandBank.new(self, filters).data + 
    NeighborhoodServices::VacancyData::ThreeEleven.new(self, filters).data +
    NeighborhoodServices::VacancyData::PropertyViolations.new(self, filters).data
  end
end
