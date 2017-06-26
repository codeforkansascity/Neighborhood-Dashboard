require 'socrata_client'

module KcmoDatasets
  class PropertyViolations
    DATASET = 'ha6k-d6qu'
    SOURCE_URI = 'https://data.kcmo.org/Housing/Property-Violations/nhtf-e75a'

    attr_accessor :requested_datasets

    def initialize(neighborhood, filters = {})
      @neighborhood = neighborhood
      @filters = filters
      @requested_datasets = filters[:filters] || []
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

    def boarded_longterm
      @requested_datasets = ['boarded_longterm']
      self
    end

    def metadata
      @metadata ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/nhtf-e75a/').response.body)
    rescue
      {}
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

      if @filters[:start_date] && @filters[:end_date]
        begin
          query_string += " AND violation_entry_date >= '#{DateTime.parse(@filters[:start_date]).iso8601[0...-6]}'"
          query_string += " AND violation_entry_date <= '#{DateTime.parse(@filters[:end_date]).iso8601[0...-6]}'"
        rescue
        end
      end

      query
    end

    def build_query_filters
      filters = []

      if @requested_datasets.include?('vacant_registry_failure')
        filters << vacant_registry_failure_query
      end

      if @requested_datasets.include?('boarded_longterm')
        filters << boarded_longterm_query
      end

      if @requested_datasets.include?('open_cases')
        filters << open_cases_query
      end

      filters.join(' OR ')
    end

    def vacant_registry_failure_query
      "violation_code = 'NSVACANT'"
    end

    def open_cases_query
      "status='Open'"
    end

    def boarded_longterm_query
      "violation_code = 'NSBOARD01'"
    end
  end
end
