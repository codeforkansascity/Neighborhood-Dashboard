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
require 'vacant_lot/neighborhood_matcher'

neighborhood_entities = []

if Neighborhood.count <= 0
  response = JSON.parse(HTTParty.get('http://api.codeforkc.org/neighborhoods-geo/V0/99?city=KANSAS%20CITY&state=MO'))
  neighborhoods = response['features']
  neighborhoods_count = neighborhoods.count
  current_neighborhood_count = 0

  puts "Now Loading Neighborhoods"

  neighborhoods.each do |neighborhood|
    possible_coordinates = neighborhood['geometry']['coordinates'][0][0]

    if possible_coordinates.present?
      coordinates = possible_coordinates.map { |coordinate|
        Coordinate.create(latitude: coordinate[1], longtitude: coordinate[0])
      }

      neighborhood_entities << Neighborhood.create(name: neighborhood['properties']['name'], coordinates: coordinates)
    end

    current_neighborhood_count += 1
    puts "Loaded #{current_neighborhood_count}/#{neighborhoods_count}"
  end
end

puts "\n\nLoading Vacant Lots"

if RegisteredVacantLot.count <= 0
  uri = URI.parse('http://webfusion.kcmo.org/coldfusionapps/neighborhood/rentalreg/PropList.cfm')
  response = Net::HTTP.get_response(uri)

  data = Nokogiri::HTML(response.body)

  data_table = data.css('table')
  table_rows = data_table.css('tr')

  vacant_lot_count = table_rows.length
  current_vacant_lot_count = 0

  table_rows.each do |table_row|
    table_cells = table_row.css('td')

    if table_cells.length == 8
      RegisteredVacantLot.create(
        property_address: table_cells[1].text.gsub(/\s+/, ' '),
        contact_person: table_cells[2].text,
        contact_address: table_cells[3].text,
        contact_phone: table_cells[4].text,
        property_type: table_cells[5].text,
        registration_type: table_cells[6].text,
        last_verified: table_cells[7].text
      )
    end

    current_vacant_lot_count += 1
    puts "Loaded #{current_vacant_lot_count}/#{vacant_lot_count}"
  end
end

VacantLot::NeighborhoodMatcher.new.match
