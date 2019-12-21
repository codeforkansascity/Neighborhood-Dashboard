class TaxDelinquencyController < ApplicationController
  def index
    @county_id = params[:county_id]

    uri = URI::escape("http://dev-api.codeforkc.org/address-attributes-county-id/V0/#{@county_id}?city=Kansas City&state=MO")
    puts "Querying #{uri}"
    address_data = JSON.parse(HTTParty.get(uri))
    @address_data = address_data['data'] || []

    @full_address = "#{@address_data['street_address'].titleize} #{@address_data['city'].try(&:titleize)} #{@address_data['state']}, #{@address_data['census_zip']}"

    render file: 'layouts/tax_delinquency.html.erb'
  end
end
