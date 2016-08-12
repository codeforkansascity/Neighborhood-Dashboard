class StaticData
  @@parcel_data ||= JSON.parse(File.read(::Rails.root.join('data_sets', 'parcel_coordinates.json')))['features']
  @@vacant_lot_data ||= JSON.parse(File.read(::Rails.root.join('data_sets', 'vacant_lots.json')))

  def self.PARCEL_DATA()
    @@parcel_data
  end

  def self.VACANT_LOT_DATA()
    @@vacant_lot_data
  end
end
