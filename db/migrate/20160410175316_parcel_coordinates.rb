class ParcelCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates_parcels do |t|
      t.belongs_to :parcel
      t.belongs_to :coordinate

      t.timestamps null: false
    end
  end
end
