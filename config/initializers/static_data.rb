class StaticData
  @@parcel_data ||= JSON.parse(File.read(::Rails.root.join('data_sets', 'parcel_coordinates.json')))['features']
  @@census_data ||= JSON.parse(File.read(::Rails.root.join('data_sets', 'census_data.json')))

  def self.PARCEL_DATA()
    @@parcel_data
  end

  def self.CENSUS_DATA()
    @@census_data
  end
end
