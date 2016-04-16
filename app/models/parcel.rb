class Parcel < ActiveRecord::Base
  has_and_belongs_to_many :coordinates
  accepts_nested_attributes_for :coordinates
end
