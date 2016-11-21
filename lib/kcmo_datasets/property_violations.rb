require 'socrata_client'

module KcmoDatasets
  class PropertyViolations
    DATASET = 'ha6k-d6qu'
    SOURCE_URI = 'https://data.kcmo.org/Housing/Property-Violations/nhtf-e75a/data'

    attr_accessor :requested_datasets

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @requested_datasets = []
    end

    def request_data
      SocrataClient.get(DATASET, build_socrata_query)
    end

    def open_cases
      @requested_datasets = ['open_cases']
      self
    end

    def vacant_registry_failure
      @requested_datasets = ['vacant_registry_failure']
      self
    end

    def self.grouped_address_counts(neighborhood)
      query =  "SELECT address, mapping_location, count(address) where #{neighborhood.within_polygon_query('mapping_location')}"
      query += " AND status !='Closed'"
      query += " GROUP BY address, mapping_location"
      SocrataClient.get(DATASET, query)
    end

    private

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('mapping_location')}"

      if @requested_datasets.present?
        query += " AND (#{build_query_filters})"
      end

      query
    end

    def build_query_filters
      filters = []

      if @requested_datasets.include?('vacant_registry_failure')
        filters << vacant_registry_failure_query
      end

      if @requested_datasets.include?('open_cases')
        filters << open_cases_query
      end

      filters.join(' OR ')
    end

    def vacant_registry_failure_query
      vacant_registry_code = ["'NSVACANT'", "'NSBOARD01'"]

      "violation_code in (#{vacant_registry_code.join(',')})"
    end

    def open_cases_query
      "status='Open'"
    end
  end
end
