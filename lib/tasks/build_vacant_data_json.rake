require 'vacant_lot/data_set_parser'

task :build_vacant_data_json => :environment do
  parser = VacantLot::DataSetParser.new
  tables = parser.tables

  neighborhoods = Neighborhood.all.each_with_object({}) do |neighborhood, hash|
    puts "Obtaining Addresses for #{neighborhood.name}"
    neighborhood_addresses = neighborhood.addresses['data']

    if neighborhood_addresses.present?
      neighborhood_addresses.each do |address|
        if address['single_line_address'].present?
          address = address['single_line_address'].split(',')
          hash[address[0]] = address
        end
      end
    end
  end

  puts neighborhoods
end

# {
#   "address_id"=>11013, 
#   "single_line_address"=>"110 PARK AVE, KANSAS CITY, MO", 
#   "city"=>"KANSAS CITY", 
#   "state"=>"MO", 
#   "zip"=>"64124", 
#   "longitude"=>"-94.5547326726", 
#   "latitude"=>"39.1132454544", 
#   "city_id"=>39910, 
#   "city_land_use_code"=>"1111 - Single Family (Non-Mobile Home Park)", 
#   "city_land_use"=>"Residential", 
#   "city_classification"=>"R-6", 
#   "city_sub_class"=>"", 
#   "city_nighborhood"=>"Pendleton Heights", 
#   "city_nhood"=>"Pendleton Heights", 
#   "city_council_district"=>"3", 
#   "county_id"=>"JA12740041700000000", 
#   "census_block_2010_name"=>"Block 1008", 
#   "census_block_2010_id"=>"1008", 
#   "census_track_name"=>"Census Tract 10", 
#   "census_track_id"=>"001000", 
#   "census_zip"=>"64124", 
#   "census_county_id"=>"095", 
#   "census_county_state_id"=>"29", 
#   "census_longitude"=>"-94.55441", 
#   "census_latitude"=>"39.11345", 
#   "census_tiger_line_id"=>"91448858", 
#   "census_metro_area"=>"Kansas City, MO-KS"
# } 