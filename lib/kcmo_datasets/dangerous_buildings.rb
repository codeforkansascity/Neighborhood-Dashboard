require 'socrata_client'

module KcmoDatasets
  class DangerousBuildings
    DATASET = 'rm2v-mbk5'
    SOURCE_URI = 'https://data.kcmo.org/Property/Dangerous-Buildings-List/ax3m-jhxx/data'

    attr_accessor :requested_datasets

    def initialize(neighborhood)
      @neighborhood = neighborhood
      @requested_datasets = []
    end

    def request_data
      SocrataClient.get(DATASET, build_socrata_query)
    end

    def metadata
      @metadata ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/rm2v-mbk5/').response.body)
    rescue
      {}
    end

    private

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('location')}"
    end
  end
end
