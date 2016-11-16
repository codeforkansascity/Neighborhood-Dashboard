# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'
require 'nokogiri'
require 'similar_text'

if Neighborhood.count <= 0
  response = JSON.parse(HTTParty.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON'))
  neighborhoods = response['features']
  neighborhoods_count = neighborhoods.count
  current_neighborhood_count = 0

  puts "Now Loading Neighborhoods"

  neighborhoods.each do |neighborhood|
    if neighborhood['properties']['nbhname'].present?
      possible_coordinates = neighborhood['geometry']['coordinates'][0][0]

      if possible_coordinates.present?
        coordinates = possible_coordinates.map { |coordinate|
          Coordinate.create(latitude: coordinate[1], longtitude: coordinate[0])
        }
      end

      Neighborhood.create(id: neighborhood['properties']['nbhid'], name: neighborhood['properties']['nbhname'], coordinates: coordinates)
    end

    current_neighborhood_count += 1
    puts "Loaded #{current_neighborhood_count}/#{neighborhoods_count}"
  end
end

