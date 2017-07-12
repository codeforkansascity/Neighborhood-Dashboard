require 'kcmo_datasets/three_eleven_cases'
require 'kcmo_datasets/property_violations'
require 'kcmo_datasets/dangerous_buildings'

class NeighborhoodServices::LegallyAbandonedCalculation
  CODE_COUNT_VIOLATION = 'code count violation'
  TAX_DELINQUENT_VIOLATION = 'tax delinquent violation'
  VACANT_RELATED_VIOLATION = 'vacant count violation'

  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def vacant_indicators
    abandoned_candidates = {}
    three_eleven_data(abandoned_candidates)
    dangerous_buildings(abandoned_candidates)
    vacant_registry_failures(abandoned_candidates)
    tax_delinquent_datasets(abandoned_candidates)
    address_violation_counts(abandoned_candidates)

    abandoned_candidates.values.select(&:legally_abandoned?)
  end

  private

  def vacant_registry_failures(abandoned_candidates = {})
    data = NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations.new(@neighborhood).calculated_data

    data.each do |(address, value)|
      abandoned_candidates[address.downcase] = Entities::LegallyAbandonedCalculation::Item.new(address) unless abandoned_candidates[address]
      abandoned_candidates[address.downcase].vacant_registry_failure_data = value
    end
  end

  def tax_delinquent_datasets(abandoned_candidates = {})
    data = NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent.new(@neighborhood).calculated_data
    
    data.each do |(address, value)|
      abandoned_candidates[address.downcase] = Entities::LegallyAbandonedCalculation::Item.new(address) unless abandoned_candidates[address]
      abandoned_candidates[address.downcase].tax_delinquent_data = value
    end
  end

  def address_violation_counts(abandoned_candidates = {})
    data = NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount.new(@neighborhood).calculated_data
    
    data.each do |(address, value)|
      abandoned_candidates[address.downcase] = Entities::LegallyAbandonedCalculation::Item.new(address) unless abandoned_candidates[address]
      abandoned_candidates[address.downcase].address_violation_count = value
    end
  end

  def three_eleven_data(abandoned_candidates = {})
    data = NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData.new(@neighborhood).calculated_data
  
    data.each do |(address, value)|
      abandoned_candidates[address.downcase] = Entities::LegallyAbandonedCalculation::Item.new(address) unless abandoned_candidates[address]
      abandoned_candidates[address.downcase].three_eleven_data = value
    end
  end

  def dangerous_buildings(abandoned_candidates = {})
    data = NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings.new(@neighborhood).calculated_data
  
    data.each do |(address, value)|
      abandoned_candidates[address.downcase] = Entities::LegallyAbandonedCalculation::Item.new(address) unless abandoned_candidates[address]
      abandoned_candidates[address.downcase].dangerous_buildings = value
    end
  end
end
