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

  def score_parcels
  end

  def tax_delinquent_data
  end

  def code_violations
  end

  def vacant_indicators
    vacant_registries = KcmoDataSets::LandBankData.new(@neighborhood)
                        .request_data

    three_eleven_data = KcmoDatasets::ThreeElevenCases.new(@neighborhood)
                        .open_cases
                        .vacant_called_in_violations
                        .request_data

    property_violations = KcmoDatasets::PropertyViolations.new(@neighborhood)
                          .vacant_registry_failure
                          .request_data

    dangerous_buildings = KcmoDatasets::DangerousBuildings.new(@neighborhood)
                          .request_data
  end

  def three_eleven_data_query
  end
end