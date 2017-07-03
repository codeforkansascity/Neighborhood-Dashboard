class NeighborhoodServices::VacancyData::TaxDelinquent
  POSSIBLE_FILTERS = ['tax_delinquent']

 def initialize(neighborhood, filters = {})
    @neighborhood = neighborhood
    @filters = filters[:filters] || []
    @start_date = filters[:start_date]
    @end_date = filters[:end_date]
  end

  def data
    tax_delinquent_data = NeighborhoodServices::VacancyData::Filters::TaxDelinquent.new(@neighborhood.addresses).filtered_data

    tax_delinquent_data
      .map{ |building| Entities::AddressApi::Address.deserialize(building) }
      .select{ |building| building.mappable? && building.tax_delinquent?}
      .map(&:to_h)
  end
end