require 'kcmo_datasets/three_eleven_cases'
require 'kcmo_datasets/property_violations'
require 'kcmo_datasets/dangerous_buildings'

class NeighborhoodServices::LegallyAbandonedCalculation
  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def vacant_indicators
    addresses = merge_dataset(three_eleven_data, {})
    addresses = merge_dataset(vacant_registries, addresses)
    addresses = merge_dataset(dangerous_buildings, addresses)
    addresses = merge_dataset(vacant_registry_failures, addresses)

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

    attach_geometric_coordinates(addresses)
      .select{ |address, value|
        value[:geometric_coordinates].present?
      }
      .map { |(address, value)|
        {
          "type" => "Feature",
          "geometry" => {
            "type" => "Polygon",
            "coordinates" => value[:geometric_coordinates]
          },
          "properties" => {
            "color" => land_bank_color(value[:points]),
            "disclosure_attributes" => value[:disclosure_attributes],
            "points" => value[:points]
          }
        }
      }
  end

  private

  def land_bank_color(points)
    case points
    when 1 then '#FFF'
    when 2 then '#CCC'
    when 3 then '#999'
    when 4 then '#666'
    when 5 then '#333'
    when 6 then '#000'
    end
  end

  def vacant_registry_failures
    NeighborhoodServices::LegallyAbandonedCalculation::PropertyViolations.new(@neighborhood).calculated_data
  end

  def tax_delinquent_datasets
    NeighborhoodServices::LegallyAbandonedCalculation::TaxDelinquent.new(@neighborhood).calculated_data
  end

  def address_violation_counts
    NeighborhoodServices::LegallyAbandonedCalculation::CodeViolationCount.new(@neighborhood).calculated_data
  end

  def three_eleven_data
    NeighborhoodServices::LegallyAbandonedCalculation::ThreeElevenData.new(@neighborhood).calculated_data
  end

  def vacant_registries
    NeighborhoodServices::LegallyAbandonedCalculation::VacantRegistries.new(@neighborhood).calculated_data
  end

  def dangerous_buildings
    NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings.new(@neighborhood).calculated_data
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

  def attach_geometric_coordinates(dataset)
    dataset_dup = dataset.dup

    parcel_coordinates = StaticData.PARCEL_DATA().each_with_object({}) do |parcel, hash|
      hash[parcel['properties']['land_ban60'].split("\n")[0].downcase] = parcel['geometry']['coordinates'][0]
    end

    dataset_dup.each do |(address, value)|
      value[:geometric_coordinates] = parcel_coordinates[address]
    end

    dataset_dup
  end
end
