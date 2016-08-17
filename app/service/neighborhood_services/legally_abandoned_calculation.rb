require 'kcmo_datasets/three_eleven_cases'
require 'kcmo_datasets/property_violations'
require 'kcmo_datasets/dangerous_buildings'

class NeighborhoodServices::LegallyAbandonedCalculation
  THREE_ELEVEN = 'cyqf-nban'
  DANGEROUS_BUILDINGS = 'rm2v-mbk5'
  PROPERTY_VIOLATIONS = 'ha6k-d6qu'
  LAND_BANK_DATA = 'n653-v74j'

  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculate
    vacant_indicators
  end

  private

  def vacant_indicators
    address = {}

    tax_delinquent_datasets
    address_violation_counts
    three_eleven_points
    vacant_registries 

    property_violations = KcmoDatasets::PropertyViolations.new(@neighborhood)
                          .vacant_registry_failure
                          .request_data

    dangerous_buildings = KcmoDatasets::DangerousBuildings.new(@neighborhood)
                          .request_data
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

      points_hash[vacant_lot['property_address']] = {
        points: 2,
        longitude: vacant_lot['longitude'],
        latitude: vacant_lot['latitude'],
        disclosure_attributes: [display]
      }
    end
  end

  def vacant_registry_failures
  end

  def merge_data_set(large_dataset, primary_dataset)
  end
end