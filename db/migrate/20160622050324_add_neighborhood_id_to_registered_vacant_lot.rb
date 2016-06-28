class AddNeighborhoodIdToRegisteredVacantLot < ActiveRecord::Migration
  def change
    add_column :registered_vacant_lots, :neighborhood_id, :integer
  end
end
