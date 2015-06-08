class Neighborhood < ActiveRecord::Base  
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address
  has_and_belongs_to_many :coordinates
  accepts_nested_attributes_for :coordinates

  def three_eleven_data
    Neighborhood::ThreeElevenData.new(self).data
  end
end
