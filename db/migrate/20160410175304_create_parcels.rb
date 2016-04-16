class CreateParcels < ActiveRecord::Migration
  def change
    create_table :parcels do |t|
      t.string :object_id
      t.string :parcel_id
      t.string :apn
      t.string :own_name
      t.string :land_bank

      t.timestamps null: false
    end
  end
end
