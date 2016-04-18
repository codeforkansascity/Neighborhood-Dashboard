class StaticData
  PARCEL_DATA ||= JSON.parse(File.read(::Rails.root.join('data_sets', 'parcel_coordinates.json')))['features']
end
