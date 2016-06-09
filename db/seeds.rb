# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Neighborhood.count <= 0
  response = HTTParty.get('https://structuralfabric.org/api/hood')

  response.parsed_response.each do |neighborhood|

    possible_coordinates = neighborhood['location']['shape']['coordinates'][0]

    if possible_coordinates.present?
      coordinates = possible_coordinates.map { |coordinate|
        Coordinate.create(latitude: coordinate[1], longtitude: coordinate[0])
      }

      Neighborhood.create(name: neighborhood['name'], coordinates: coordinates)
    end
  end
end
