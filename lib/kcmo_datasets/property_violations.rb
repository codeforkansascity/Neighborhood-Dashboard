require 'socrata_client'

module KcmoDatasets
  class PropertyViolations
    DATASET = 'ha6k-d6qu'

    attr_accessor :requested_datasets

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @requested_datasets = []
    end

    def request_data
      SocrataClient.get(DATASET, build_socrata_query)
    end

    def vacant_registry_failure
      @requested_datasets = ['vacant_registry_failure']
      self
    end

    def self.grouped_address_counts(@neighborhood)
      query =  "SELECT address, count(address) where #{@neighborhood.within_polygon_query('mapping_location')}"
      query += " GROUP BY address"

    end

    private

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('mapping_location')}"

      if @requested_datasets.present?
        query += " AND (#{build_query_filters})"
      end
    end

    def build_query_filters
      filters = []

      if @requested_datasets.include?('vacant_registry_failure')
        filters << vacant_registry_failure_query
      end

      filters.join(' OR ')
    end

    def vacant_registry_failure_query
      vacant_registry_code = ["'NSVACANT'", "'NSBOARD01'"]

      "violation_code in (#{vacant_registry_code.join(',')})"
    end    
  end
end
