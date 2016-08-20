require 'socrata_client'

module KcmoDatasets
  class DangerousBuildings
    DATASET = 'rm2v-mbk5'

    attr_accessor :requested_datasets

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @requested_datasets = []
    end

    def request_data
      SocrataClient.get(DATASET, build_socrata_query)
    end

    private

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('location')}"
    end
  end
end
