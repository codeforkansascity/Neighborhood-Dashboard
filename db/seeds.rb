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


if Parcel.count <= 0
  parcel_data = File.read(::Rails.root.join('data_sets', 'parcel_coordinates.json'))
  parcel_json = JSON.parse(parcel_data)

  parcel_json['features'].each do |parcel|
    coordinates = parcel["geometry"]["coordinates"][0][0].map do |coordinate|
      Coordinate.new(latitude: coordinate[1], longtitude: coordinate[0])
    end

    parcel_properties = parcel['properties']

    parcel_model = Parcel.create(
      object_id: parcel_properties['objectid'],
      parcel_id: parcel_properties['parcelid'],
      apn: parcel_properties['apn'],
      own_name: parcel_properties['own_name'],
      land_bank: parcel_properties['land_bank'],
      coordinates: coordinates
    )
  end
end
