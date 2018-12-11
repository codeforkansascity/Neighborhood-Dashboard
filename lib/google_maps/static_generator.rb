module GoogleMaps
  class StaticGenerator
    def initialize(neighborhood, markers = [])
      @neighborhood = neighborhood
      @markers = markers
    end

    def generate_static_api_uri
      query_parameters = "#{styles}#{neighborhood_center}#{generate_path}#{api_key}#{markers_parameter}"
      puts 'Map URI'
      puts "https://maps.googleapis.com/maps/api/staticmap?#{query_parameters}"
      URI::escape("https://maps.googleapis.com/maps/api/staticmap?#{query_parameters}")
    end

    private

    def api_key
      '&key=AIzaSyCJnHS662l7UYK3EKYDwwuGtaFfnlc1qBU'
    end

    def styles
      "&size=800x400&zoom=15"
    end

    def neighborhood_center
      if @neighborhood.center.present?
        "&center=#{@neighborhood.center[:latitude]},#{@neighborhood.center[:longtitude]}"
      else
        ''
      end
    end

    def markers_parameter
      @markers.inject("") do |query_string, marker|
        query_string += "&markers=color:0x#{marker[:color]}|label:#{marker[:label]}|#{marker[:data].latitude},#{marker[:data].longitude}"
        query_string
      end
    end

    def generate_path
      encoded_polyfill = Polylines::Encoder.encode_points(
        @neighborhood.coordinates.map do |coordinate| 
          [coordinate.latitude, coordinate.longtitude]
        end
      )

      "&path=weight:3|fillcolor:0x00000033|color:0x000000|enc:#{encoded_polyfill}"
    end
  end
end