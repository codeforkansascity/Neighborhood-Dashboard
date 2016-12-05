require 'socrata_client'

module KcmoDatasets
  class ThreeElevenCases
    DATASET = 'cyqf-nban'
    SOURCE_URI = 'https://data.kcmo.org/311/311-Call-Center-Service-Requests/7at3-sxhp/data'

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

    def metadata
      @metadata ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/cyqf-nban/').response.body)
    rescue
      {}
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
        "'Animals / Pets-Rat Treatment-Vacant Home'",
        "'Animals / Pets-Rat Treatment-Vacant Property'",
        "'Cleaning vacant Land Trust Lots'",
        "'Mowing / Weeds-Public Property-City Vacant Lot'",
        "'Nuisance Violations on Private Property Vacant Structure'",
        "'Vacant Structure Open to Entry'"
      ]

      "request_type in (#{vacant_violations.join(',')})"
    end

    def open_cases_query
      "status='OPEN'"
    end
  end
end
