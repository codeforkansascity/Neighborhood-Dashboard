require 'kcmo_datasets/three_eleven_cases'
require 'kcmo_datasets/property_violations'
require 'kcmo_datasets/dangerous_buildings'

class NeighborhoodServices::LegallyAbandonedCalculation
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def vacant_indicators
    addresses = merge_dataset(three_eleven_points, {})
    addresses = merge_dataset(vacant_registries, addresses)
    addresses = merge_dataset(dangerous_buildings, addresses)
    addresses = merge_dataset(property_violations, addresses)

    # For the first 4 categories, a max of 2 points can be awarded
    addresses.each do |(k,v)|
      v[:points] = [v[:points], 2].min
    end

    addresses = merge_dataset(tax_delinquent_datasets, addresses)
    addresses = merge_dataset(address_violation_counts, addresses)

    # We can have instances where the same violation appears twice in a disclosure 
    # array. We only want the violation to appear once in the disclosure array
    addresses.each do |(k,v)|
      v[:disclosure_attributes].uniq!
    end

    addresses
  end

  private

  def property_violations
    property_violations = KcmoDatasets::PropertyViolations.new(@neighborhood)
                          .vacant_registry_failure
                          .request_data

    property_violations.each_with_object({}) do |violation, hash|
      street_address = violation['address'].downcase

      if street_address
        hash[street_address] = {
          points: 1,
          longitude: violation['mapping_location']['coordinates'][1].to_f,
          latitude: violation['mapping_location']['coordinates'][0].to_f,
          disclosure_attributes: [violation['violation_description'].titleize]
        }
      end
    end
  end

  def tax_delinquent_datasets
    addresses = @neighborhood.addresses['data']
    NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent.new(addresses).calculated_data
  end

  def address_violation_counts
    violation_counts = KcmoDatasets::PropertyViolations.grouped_address_counts(@neighborhood)
    NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount.new(violation_counts).calculated_data
  end

  def three_eleven_points
    three_eleven_data = KcmoDatasets::ThreeElevenCases.new(@neighborhood)
                        .open_cases
                        .vacant_called_in_violations
                        .request_data

    three_eleven_data.each_with_object({}) do |violation, hash|
      street_address = violation['street_address'].downcase

      if street_address
        if hash[street_address]
          hash[street_address][:points] += 1
          hash[street_address][:disclosure_attributes] << violation['request_type']
        else
          hash[street_address] = {
            points: 1,
            longitude: violation['address_with_geocode']['coordinates'][1].to_f,
            latitude: violation['address_with_geocode']['coordinates'][0].to_f,
            disclosure_attributes: [violation['request_type']]
          }
        end
      end
    end
  end

  def vacant_registries
    vacant_lots = StaticData::VACANT_LOT_DATA().select{ |lot| lot['neighborhood'] == @neighborhood.name }

    vacant_lots.each_with_object({}) do |vacant_lot, points_hash|
      display = "<b>Registration Type:</b> #{vacant_lot['registration_type']}<br/><b>Last Verified: #{vacant_lot['last_verified']}</b>"

      points_hash[vacant_lot['property_address'].downcase] = {
        points: 2,
        longitude: vacant_lot['longitude'],
        latitude: vacant_lot['latitude'],
        disclosure_attributes: [display]
      }
    end
  end

  def vacant_registry_failures
    dangerous_buildings = KcmoDatasets::DangerousBuildings.new(@neighborhood)
                          .request_data
  end

  def dangerous_buildings
    dangerous_buildings = KcmoDatasets::DangerousBuildings.new(@neighborhood)
                          .request_data

    dangerous_buildings.each_with_object({}) do |dangerous_building, points_hash|
      address = dangerous_building['location'].downcase

      if address
        points_hash[address] = {
          points: 2,
          longitude: dangerous_building['location']['coordinates'][1].to_f,
          latitude: dangerous_building['location']['coordinates'][0].to_f,
          disclosure_attributes: [dangerous_building['statusofcase']]
        }
      end
    end
  end

  def merge_dataset(primary_dataset, combined_dataset)
    combined_dataset_dup = combined_dataset.dup

    primary_dataset.each do |(k,v)|
      if combined_dataset_dup[k].present?
        combined_dataset_dup[k][:points] += v[:points]
        combined_dataset_dup[k][:disclosure_attributes] += v[:disclosure_attributes]
      else
        combined_dataset_dup[k] = v
      end
    end

    combined_dataset_dup
  end
end