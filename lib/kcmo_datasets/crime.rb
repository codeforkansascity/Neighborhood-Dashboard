require 'socrata_client'
require 'crime_mapper'

module KcmoDatasets
  REGULAR_DATASOURCE_2014 = 'yu5f-iqbp'
  API_DATASOURCE_2014 = 'nsn9-g8a4'

  REGULAR_DATASOURCE_2015 = 'kbzx-7ehe'
  API_DATASOURCE_2015 = 'geta-wrqs'

  REGULAR_DATASOURCE_2016 = 'wbz8-pdv7'
  API_DATASOURCE_2016 = 'c6e8-258d'

  class Crime
    CRIME_SOURCE_2014_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2014/yu5f-iqbp/'
    CRIME_SOURCE_2015_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2015/kbzx-7ehe/'
    CRIME_SOURCE_2016_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2016/wbz8-pdv7/'

    def initialize(neighborhood, options)
      @neighborhood = neighborhood
      @options = options
    end

    def fetch_metadata_2014
      @metadata_2014 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/nsn9-g8a4/').response.body)
    rescue
      {}
    end

    def fetch_metadata_2015
      @metadata_2015 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/geta-wrqs/').response.body)
    rescue
      {}
    end

    def fetch_metadata_2016
      @metadata_2016 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/c6e8-258d/').response.body)
    rescue
      {}
    end

    def query_data
      beginning_date = parse_date(@options[:start_date])
      end_date = parse_date(@options[:end_date])

      crime = []

      if beginning_date || end_date
        if beginning_date.try(&:year) == 2014 || end_date.try(&:year) == 2014
          crime << query(API_DATASOURCE_2014).each do |crime|
            crime['dataset_year'] = 2014
            crime['source'] = CRIME_SOURCE_2014_URI
            crime['last_updated'] = fetch_metadata_2014['rowsUpdatedAt']
          end
        end

        if beginning_date.try(&:year) == 2015 || end_date.try(&:year) == 2015
          crime << query(API_DATASOURCE_2015).each do
            crime['dataset_year'] = 2015
            crime['source'] = CRIME_SOURCE_2015_URI
            crime['last_updated'] = fetch_metadata_2015['rowsUpdatedAt']
          end
        end

        if beginning_date.try(&:year) == 2016 || end_date.try(&:year) == 2016
          crime << query(API_DATASOURCE_2016).each do |crime|
            crime['dataset_year'] = 2016
            crime['source'] = CRIME_SOURCE_2016_URI
            crime['last_updated'] = fetch_metadata_2016['rowsUpdatedAt']
          end
        end
      else
        crime << query(API_DATASOURCE_2014).each do |crime|
          crime['dataset_year'] = 2014
          crime['source'] = CRIME_SOURCE_2014_URI
          crime['last_updated'] = fetch_metadata_2014['rowsUpdatedAt']
        end

        crime << query(API_DATASOURCE_2015).each do |crime|
          crime['dataset_year'] = 2015
          crime['source'] = CRIME_SOURCE_2015_URI
          crime['last_updated'] = fetch_metadata_2015['rowsUpdatedAt']
        end

        crime << query(API_DATASOURCE_2016).each do |crime|
          crime['dataset_year'] = 2016
          crime['source'] = CRIME_SOURCE_2016_URI
          crime['last_updated'] = fetch_metadata_2016['rowsUpdatedAt']
        end
      end

      crime.flatten
    end

    def grouped_totals
      query = "SELECT ibrs, count(ibrs) WHERE #{@neighborhood.within_polygon_query('location_1')} GROUP BY ibrs"

      crimes = SocrataClient.get(API_DATASOURCE_2016, query)

      crime_counts = crimes.inject({}) {|crime_hash, crime|
        crime_hash.merge(crime['ibrs'] => crime['count_ibrs'])
      }

      crime_counts
    end

    private

    def query(data_source)
      SocrataClient.get(data_source, build_socrata_query)
    end

    def build_socrata_query
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query('location_1')}"

      beginning_date = parse_date(@options[:start_date])
      end_date = parse_date(@options[:end_date])
      crime_codes = @options[:crime_codes] || []

      if beginning_date
        query += " AND from_date >= '#{beginning_date.iso8601[0...-6]}'"
      end

      if end_date
        query += " AND from_date <= '#{end_date.iso8601[0...-6]}'"
      end

      if crime_codes.present?
        query += " AND #{process_crime_filters(crime_codes)}"
      end

      query
    end

    def process_crime_filters(crime_codes)
      if crime_codes.present?
        crime_code_filter = crime_codes.join("' OR ibrs='")
        "(ibrs = '#{crime_code_filter}')"
      else
        ""
      end
    end

    def parse_date(date)
      DateTime.parse(date)
    rescue
      nil
    end
  end
end
