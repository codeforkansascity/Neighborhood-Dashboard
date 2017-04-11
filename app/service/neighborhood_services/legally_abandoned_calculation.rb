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
    addresses = merge_dataset(three_eleven_data, {})
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

    addresses = addresses.select { |address, value|
      value[:categories].include?(NeighborhoodServices::LegallyAbandonedCalculation::CODE_COUNT_VIOLATION) &&
      value[:categories].include?(NeighborhoodServices::LegallyAbandonedCalculation::TAX_DELINQUENT_VIOLATION) &&
      value[:categories].include?(NeighborhoodServices::LegallyAbandonedCalculation::VACANT_RELATED_VIOLATION)
    }

    attach_geometric_data(addresses)
      .map { |(address, value)|
        full_address = "#{address.titleize}<br/>#{value[:city].try(&:titleize)} #{value[:state]}, #{value[:zip]}"

        {
          "type" => "Feature",
          "geometry" => value[:geometry],
          "properties" => {
            "marker_style" => value[:geometry]["type"] == 'Point' ? 'circle' : nil,
            "color" => land_bank_color(value[:points]),
            "disclosure_attributes" =>
              [
                '<h3 class="info-window-header">Address</h3>',
                "<address>#{full_address}</address>",
                '<h3 class="info-window-header">Owner</h3>',
                value[:owner] || 'Not Available'
              ] +
              value[:disclosure_attributes],
            "points" => value[:points],
            "address" => address
          }
        }
      }
  end

  private

  def land_bank_color(points)
    case points
    when 6 then '#000'
    when 5 then '#444'
    when 4 then '#888'
    when 3 then '#CCC'
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

  def dangerous_buildings
    NeighborhoodServices::LegallyAbandonedCalculation::DangerousBuildings.new(@neighborhood).calculated_data
  end

  def merge_dataset(primary_dataset, combined_dataset)
    combined_dataset_dup = combined_dataset.dup

    primary_dataset.each do |(k,v)|
      if combined_dataset_dup[k].present?
        combined_dataset_dup[k][:points] += v[:points]
        combined_dataset_dup[k][:disclosure_attributes] += v[:disclosure_attributes]
        combined_dataset_dup[k][:categories] += v[:categories]

        if v[:zip].present?
          combined_dataset_dup[k][:zip] = v[:zip]
        end

        if v[:state].present?
          combined_dataset_dup[k][:state] = v[:state]
        end

        if v[:city].present?
          combined_dataset_dup[k][:city] = v[:city]
        end

        if v[:owner].present?
          combined_dataset_dup[k][:owner] = v[:owner]
        end

      else
        combined_dataset_dup[k] = v.dup
      end

      
    end

    combined_dataset_dup
  end

  def attach_geometric_data(addresses)
    addresses_dup = addresses.dup

    parcel_coordinates = StaticData.PARCEL_DATA().each_with_object({}) do |parcel, hash|
      hash[parcel['properties']['land_ban60'].split("\n")[0].downcase] = parcel['geometry']['coordinates'][0]
    end

    addresses_dup.each do |(address, value)|
      if parcel_coordinates[address].present?
        value[:geometry] = {
          "type" => "Polygon",
          "coordinates" => parcel_coordinates[address]
        }
      else
        value[:geometry] = {
          "type" => "Point",
          "coordinates" => [value[:longitude].to_f, value[:latitude].to_f]
        }
      end
    end

    addresses_dup
  end
end
