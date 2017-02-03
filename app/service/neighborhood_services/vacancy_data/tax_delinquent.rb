class NeighborhoodServices::VacancyData::TaxDelinquent
  POSSIBLE_FILTERS = ['tax_delinquent']

 def initialize(neighborhood, filters = {})
    @neighborhood = neighborhood
    @filters = filters[:filters] || []
    @start_date = filters[:start_date]
    @end_date = filters[:end_date]
  end

  def data
    return @data unless @data.nil?

    querable_dataset = POSSIBLE_FILTERS.any? { |filter|
      @filters.include? filter
    }

    if querable_dataset
      @data ||= query_dataset
    else
      @data ||= []
    end
  end

  private 

  def query_dataset
    tax_delinquent_data = NeighborhoodServices::VacancyData::Filters::TaxDelinquent.new(@neighborhood.addresses).filtered_data

    tax_delinquent_data
      .select { |address|
        address['longitude'].present? && address['latitude'].present?
      }
      .map { |address|
        {
          'type' => 'Feature',
          'geometry' => {
            'type' => 'Point',
            'coordinates' => [address['longitude'].to_f, address['latitude'].to_f]
          },
          'properties' => {
            'color' => '#ffffff',
            'disclosure_attributes' => address['disclosure_attributes']
          }
        }
      }
  end
end