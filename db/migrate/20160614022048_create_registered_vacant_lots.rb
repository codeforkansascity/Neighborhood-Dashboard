class CreateRegisteredVacantLots < ActiveRecord::Migration
  def change
    create_table :registered_vacant_lots do |t|
      t.string :property_address
      t.text :contact_person
      t.text :contact_address
      t.float :latitude
      t.float :longitude
      t.string :contact_phone
      t.string :property_type
      t.string :registration_type
      t.datetime :last_verified

      t.timestamps null: false
    end
  end
end
