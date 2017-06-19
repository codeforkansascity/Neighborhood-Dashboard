require 'kcmo_datasets/crime'

class NeighborhoodServices::Crime
  def initialize(neighborhood_id, options = {})
    @neighborhood_id = neighborhood_id
    @options = options
  end

  def grouped_totals
    @dataset ||= KcmoDatasets::Crime.new(Neighborhood.find(@neighborhood_id), @options)
    CrimeMapper.convert_crime_key_to_application_key(@dataset.grouped_totals)
  end

  def mapped_coordinates
    @dataset ||= KcmoDatasets::Crime.new(Neighborhood.find(@neighborhood_id), @options)
    @dataset.query_data
      .map{ |coordinate| Entities::Crime.deserialize(coordinate) }
      .select(&Entities::GeoJson::MAPPABLE_ITEMS)
      .map(&:to_h)
  end
end
