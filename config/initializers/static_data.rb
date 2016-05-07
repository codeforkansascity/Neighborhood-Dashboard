class StaticData
  @@parcel_data ||= JSON.parse(File.read(::Rails.root.join('data_sets', 'parcel_coordinates.json')))['features']

  def self.PARCEL_DATA()
    @@parcel_data
  end
end
