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

  def three_eleven_points
    three_eleven_data = KcmoDatasets::ThreeElevenCases.new(@neighborhood)
                        .open_cases
                        .vacant_called_in_violations
                        .request_data

    binding.pry

    three_eleven_data.each_with_object({}) do |violation, hash|
      if hash[violation['street_address'].downcase]
        hash[violation['street_address'].downcase][:points] += 1
        hash[violation['street_address'].downcase] += violation['violation_description']
      else
        hash[violation['street_address'].downcase] = {
          points: 1,
          longitude: violation['address_with_geocode']['coordinates'][1].to_f,
          latitude: violation['address_with_geocode']['coordinates'][0].to_f,
          disclosure_attributes: [violation['violation_description']]
        }
      end
    end
  end

  private

  def vacant_indicators
    address = {}

    tax_delinquent_datasets
    address_violation_counts

    vacant_registries = KcmoDataSets::LandBankData.new(@neighborhood)
                        .request_data

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

  def merge_data_set(large_dataset, primary_dataset)
  end
end