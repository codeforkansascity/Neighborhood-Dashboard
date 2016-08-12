require 'vacant_lot/data_set_parser'

task :build_vacant_data_json => :environment do
  vacant_lot_parser = VacantLot::DataSetParser.new
  vacant_lots = vacant_lot_parser.data

  neighborhood_addresses = Neighborhood.all.each_with_object({}) do |neighborhood, hash|
    puts "Obtaining Addresses for #{neighborhood.name}"
    neighborhood_addresses = neighborhood.addresses['data']

    if neighborhood_addresses.present?
      neighborhood_addresses.each do |address|
        if address['street_address'].present?
          hash[address['street_address'].downcase] = {
            neighborhood: neighborhood.name,
            latitude: address['latitude'],
            longitude: address['longitude']
          }
        end
      end
    end
  end

  vacant_lots.map! do |lot| 
    if neighborhood_addresses[lot[:property_address].downcase]
      lot.merge(neighborhood_addresses[lot[:property_address].downcase])
    else
      nil
    end
  end

  File.open("data_sets/vacant_lots.json", "w") do |f|
    f.write(vacant_lots.compact.to_json)
  end

  puts 'Vacant Lots JSON created successfully'
end
