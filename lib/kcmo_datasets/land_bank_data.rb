require 'socrata_client'

module KcmoDatasets
  class LandBankData
    DATASET = 'n653-v74j'

    attr_accessor :filters

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @filters = {}
    end

    def request_data
      SocrataClient.get(DATASET, build_socrata_query)
    end

    def metadata
      @metadata ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/n653-v74j/').response.body)
    rescue
      {}
    end

    private

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('location_1')}"
      query_elements = []
      data_filters = @filters[:data_filters] || []

      if data_filters.include?('demo_needed')
        query_elements << "demo_needed='Y'"
      end

      if data_filters.include?('foreclosed')
        query_elements << "(foreclosure_year IS NOT NULL)"
      end

      if data_filters.include?('landbank_vacant_lots')
        query_elements << "property_condition like 'Vacant lot or land%'"
      end

      if data_filters.include?('landbank_vacant_structures')
        query_elements << "property_condition like 'Structure%'"
      end

      if query_elements.present?
        query += " AND (#{query_elements.join(' or ')})"
      end

      if @filters[:start_date] && @filters[:end_date]
        begin
          query += " AND acquisition_date >= '#{DateTime.parse(@filters[:start_date]).iso8601[0...-6]}'"
          query += " AND acquisition_date <= '#{DateTime.parse(@filters[:end_date]).iso8601[0...-6]}'"
        rescue
        end
      end

      query
    end
  end
end
