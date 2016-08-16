require 'socrata_client'

module KcmoDatasets
  class ThreeElevenCases
    DATASET = 'cyqf-nban'

    attr_accessor :requested_datasets

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @requested_datasets = []
    end

    def request_data
      SocrataClient.get(DATASET, build_socrata_query)
    end

    def vacant_called_in_violations
      @requested_datasets << 'vacant_called_in'
      self
    end

    def open_cases
      @requested_datasets << 'open_cases'
      self
    end

    private

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('address_with_geocode')}"

      if @requested_datasets.present?
        query += " AND (#{build_query_filters})"
      end

      query
    end

    def build_query_filters
      filters = []

      if @requested_datasets.include?('vacant_called_in')
        filters << vacant_called_in_violations_query
      end

      if @requested_datasets.include?('open_cases')
        filters << open_cases_query
      end

      filters.join(' OR ')
    end

    def vacant_called_in_violations_query
      vacant_violations = [
        "'Animals / Pets-Rat Treatment-Vacant Property'", 
        "'Nuisance Violations on Private Property Vacant Structure'",
        "'Vacant Structure Open to Entry'"
      ]

      "request_type in ('','','')"
    end

    def open_cases_query
      "status='OPEN'"
    end
  end
end
