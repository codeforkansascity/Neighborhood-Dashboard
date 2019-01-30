require 'socrata_client'
require 'crime_mapper'

module KcmoDatasets

  LEGACY_LOCATION_FIELD = 'location_1'
  NEW_LOCATION_FIELD = 'location'

  REGULAR_DATASOURCE_2016 = 'wbz8-pdv7'
  API_DATASOURCE_2016 = 'c6e8-258d'

  REGULAR_DATASOURCE_2017 = '98is-shjt'
  API_DATASOURCE_2017 = 'wy8a-bydn'

  REGULAR_DATASOURCE_2018 = 'dmjw-d28i'
  API_DATASOURCE_2018 = 'nyg5-tzkz'

  REGULAR_DATASOURCE_2019 = 'pxaa-ahcm'
  API_DATASOURCE_2019 = 'b9da-4mi6'

  class Crime
    CRIME_SOURCE_2016_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2016/wbz8-pdv7/'
    CRIME_SOURCE_2017_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2017/98is-shjt/'
    CRIME_SOURCE_2018_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2018/dmjw-d28i/'
    CRIME_SOURCE_2019_URI = 'https://data.kcmo.org/Crime/KCPD-Crime-Data-2018/pxaa-ahcm/'

    def initialize(neighborhood, options)
      @neighborhood = neighborhood
      @options = options
    end

    def fetch_metadata_2016
      @metadata_2016 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/c6e8-258d/').response.body)
    rescue
      {}
    end

    def fetch_metadata_2017
      @metadata_2017 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/wy8a-bydn/').response.body)
    rescue
      {}
    end

    def fetch_metadata_2018
      @metadata_2018 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/nyg5-tzkz/').response.body)
    rescue
      {}
    end

    def fetch_metadata_2019
      @metadata_2019 ||= JSON.parse(HTTParty.get('https://data.kcmo.org/api/views/b9da-4mi6/').response.body)
    rescue
      {}
    end

    def query_data
      puts '== trace -> query_data =='

      beginning_date = parse_date(@options[:start_date])
      end_date = parse_date(@options[:end_date])

      crime = []

      if beginning_date || end_date
        if beginning_date.try(&:year) == 2016 || end_date.try(&:year) == 2016
          crime << query(API_DATASOURCE_2016, LEGACY_LOCATION_FIELD).each do |crime|
            crime['dataset_year'] = 2016
            crime['source'] = CRIME_SOURCE_2016_URI
            crime['last_updated'] = fetch_metadata_2016['rowsUpdatedAt']
          end
        end

        if beginning_date.try(&:year) == 2017 || end_date.try(&:year) == 2017
          puts '== trace -> using 2017 in a crime query =='
          crime << query(API_DATASOURCE_2017, LEGACY_LOCATION_FIELD).each do |crime|
            crime['dataset_year'] = 2017
            crime['source'] = CRIME_SOURCE_2017_URI
            crime['last_updated'] = fetch_metadata_2017['rowsUpdatedAt']
          end
        end

        if beginning_date.try(&:year) == 2018 || end_date.try(&:year) == 2018
          puts '== trace -> using 2018 in a crime query =='
          crime << query(API_DATASOURCE_2018, NEW_LOCATION_FIELD).each do |crime|
            crime['dataset_year'] = 2018
            crime['source'] = CRIME_SOURCE_2018_URI
            crime['last_updated'] = fetch_metadata_2018['rowsUpdatedAt']
          end
        end

        if beginning_date.try(&:year) == 2019 || end_date.try(&:year) == 2019
          puts '== trace -> using 2019 in a crime query =='
          crime << query(API_DATASOURCE_2019, NEW_LOCATION_FIELD).each do |crime|
            crime['dataset_year'] = 2019
            crime['source'] = CRIME_SOURCE_2019_URI
            crime['last_updated'] = fetch_metadata_2019['rowsUpdatedAt']
          end
        end

      else
        crime << query(API_DATASOURCE_2016, LEGACY_LOCATION_FIELD).each do |crime|
          crime['dataset_year'] = 2016
          crime['source'] = CRIME_SOURCE_2016_URI
          crime['last_updated'] = fetch_metadata_2016['rowsUpdatedAt']
        end

        crime << query(API_DATASOURCE_2017, LEGACY_LOCATION_FIELD).each do |crime|
          crime['dataset_year'] = 2017
          crime['source'] = CRIME_SOURCE_2017_URI
          crime['last_updated'] = fetch_metadata_2017['rowsUpdatedAt']
        end

        crime << query(API_DATASOURCE_2018, NEW_LOCATION_FIELD).each do |crime|
          crime['dataset_year'] = 2018
          crime['source'] = CRIME_SOURCE_2018_URI
          crime['last_updated'] = fetch_metadata_2018['rowsUpdatedAt']
        end

        crime << query(API_DATASOURCE_2019, NEW_LOCATION_FIELD).each do |crime|
          crime['dataset_year'] = 2019
          crime['source'] = CRIME_SOURCE_2019_URI
          crime['last_updated'] = fetch_metadata_2019['rowsUpdatedAt']
        end

      end

      crime.flatten
    end

    def grouped_totals
      query = "SELECT ibrs, count(ibrs) WHERE #{@neighborhood.within_polygon_query('location')} GROUP BY ibrs"

      crimes = SocrataClient.get(API_DATASOURCE_2018, query)

      crime_counts = crimes.inject({}) {|crime_hash, crime|
        crime_hash.merge(crime['ibrs'] => crime['count_ibrs'])
      }

      crime_counts
    end

    private

    def query(data_source, location_field)
      puts '== entering query =='
      SocrataClient.get(data_source, build_socrata_query(location_field))
    end

    def build_socrata_query(location_field_name)
      query = "SELECT * WHERE #{@neighborhood.within_polygon_query(location_field_name)}"

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
