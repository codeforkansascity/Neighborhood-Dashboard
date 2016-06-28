module VacantLot
  class NeighborhoodMatcher
    def initialize
      @vacant_lots = RegisteredVacantLot.order(:property_address)
      @neighborhoods = Neighborhood.all
    end

    def test_neighborhood
      neighborhood = @neighborhoods.find{|hood| hood.id == 100}

      vacant_lots = neighborhood.addresses['data'].map do |address|
        if address['single_line_address'].present?
          vacant_lot = find_vacant_lot(address['single_line_address'].split(',').first, @vacant_lots)
          if vacant_lot.present?
            vacant_lot.update(
              latitude: address['census_latitude'].to_f, 
              longitude: address['census_longitude'].to_f
            )

            vacant_lot
          end
        end
      end

      vacant_lot_ids = vacant_lots.compact.map(&:id)
      RegisteredVacantLot.where(id: vacant_lot_ids).update_all(neighborhood_id: neighborhood.id)
    end

    def match
      @neighborhoods.each do |neighborhood|
        puts "Now matching addresses in #{neighborhood.name}"
        addresses = neighborhood.addresses

        if addresses.present?
          vacant_lots = addresses['data'].map do |address|
            if address['single_line_address'].present?
              vacant_lot = find_vacant_lot(address['single_line_address'].split(',').first, @vacant_lots)

              if vacant_lot.present?
                vacant_lot.update(
                  latitude: address['census_latitude'].to_f, 
                  longitude: address['census_longitude'].to_f
                )

                vacant_lot 
              end
            end
          end

          vacant_lot_ids = vacant_lots.compact.map(&:id)
          RegisteredVacantLot.where(id: vacant_lot_ids).update_all(neighborhood_id: neighborhood.id)
        end
      end
    end

    private

    def find_vacant_lot(target_address, vacant_lots)
      i = 0
      j = vacant_lots.length

      while(i < j) do
        current_index = ((i + j) / 2).to_i
        current_lot = vacant_lots[current_index].property_address

        downcased_current_lot = current_lot.downcase
        downcased_target_address = target_address.downcase

        if downcased_current_lot.include?(downcased_target_address) &&
           downcased_current_lot.similar(downcased_target_address) >= 80
          return vacant_lots[((i + j) / 2).to_i]
        elsif current_lot <= target_address
          i = current_index + 1
        else
          j = current_index - 1
        end
      end
    end
  end
end
