require 'socrata_client'

module KcmoDatasets
  class LandBankData
    DATASET = 'n653-v74j'

    attr_accessor :requested_datasets

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @requested_datasets = []
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
    end
  end
end
