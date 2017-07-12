class NeighborhoodServices::VacancyData::TaxDelinquent
  POSSIBLE_FILTERS = ['tax_delinquent']

 def initialize(neighborhood, filters = {})
    @neighborhood = neighborhood
    @filters = filters[:filters] || []
    @start_date = filters[:start_date]
    @end_date = filters[:end_date]
  end

  def data
    @neighborhood.addresses
      .map{ |building| Entities::AddressApi::Address.deserialize(building) }
      .select{ |building| building.mappable? && building.tax_delinquent?}
  end
end