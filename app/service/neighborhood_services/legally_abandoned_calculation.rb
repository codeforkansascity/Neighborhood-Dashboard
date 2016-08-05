class NeighborhoodServices::LegallyAbandonedCalculation
  THREE_ELEVEN = 'cyqf-nban'
  DANGEROUS_BUILDINGS = 'rm2v-mbk5'
  PROPERTY_VIOLATIONS = 'ha6k-d6qu'
  LAND_BANK_DATA = 'n653-v74j'

  def initialize(neighborhood)
    @neighborhood = neighborhood
  end

  def calculate

  end

  private

  def score_parcels
  end

  def tax_delinquent_data
  end

  def code_violations
  end

  def vacant_indicators
    property_violations = ['NSVACANT']
    NeighborhoodServices::VacancyData::PropertyViolations.new(@neighborhood).data

    three_eleven_query_elements = []
    three_eleven_query_elements << "request_type='Nuisance Violations on Private Property Vacant Structure'"
    three_eleven_query_elements << "request_type='Vacant Structure Open to Entry'"
    three_eleven_query_elements << "status='OPEN'"

    neighborhood_within_polygon = 
    three_eleven_query = "SELECT * where #{@neighborhood.within_polygon_query()} AND (#{three_eleven_query_elements})"


    SocrataClient.get(DATA_SOURCE, build_socrata_query)
    # 311 Code Data

  end

  def three_eleven_data_query
  end
end