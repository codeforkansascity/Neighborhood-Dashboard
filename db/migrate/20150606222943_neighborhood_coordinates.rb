class NeighborhoodCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates_neighborhoods do |t|
      t.belongs_to :neighborhood
      t.belongs_to :coordinate

      t.timestamps null: false
    end
  end
end
