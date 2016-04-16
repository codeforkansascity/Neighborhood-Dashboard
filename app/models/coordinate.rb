class Coordinate < ActiveRecord::Base
  has_and_belongs_to_many :neighborhoods
  has_and_belongs_to_many :parcels
end
