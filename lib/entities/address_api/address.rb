module Entities::AddressApi
  class Address < ::Entities::GeoJson
    attr_accessor :longitude, :latitude

    def disclosure_attributes
      full_address = "#{@street_address.titleize}<br/>#{@city.try(&:titleize)} #{@state}, #{@census_zip}"

      [
        "<b>Address</b>",
        "<address>#{full_address}</address>",
        '<b>Tax Delinquent Years</b>',
        tax_delinquent_years
      ].flatten
    end

    def properties
      {
        'color' => '#ffffff'
      }
    end

    def geometry
      {
        'type' => 'Point',
        'coordinates' => [longitude.to_f, latitude.to_f]
      }
    end

    def mappable?
      geometry['coordinates'].present?
    end

    def tax_delinquent?
      consecutive_years > 0
    end

    def consecutive_years
      consecutive_years = 0
      possible_years = Array(2010..2015).reverse

      possible_years.each do |year|
        if self.instance_variable_get("@county_delinquent_tax_#{year}").to_f > 0
          consecutive_years += 1
        else
          break
        end
      end

      consecutive_years
    end

    def latitude
      @latitude
    end

    def longitude
      @longitude
    end

    def address
      @street_address
    end

    private

    def tax_delinquent_years
      years = []
      possible_years = Array(2010..2015).reverse

      possible_years.each do |year|
        if self.instance_variable_get("@county_delinquent_tax_#{year}").to_f > 0
          years << ["Tax Delinquent in #{year}"]
        else
          break
        end
      end

      years
    end
  end
end
