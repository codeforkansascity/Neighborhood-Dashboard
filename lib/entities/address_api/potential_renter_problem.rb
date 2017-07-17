module Entities::AddressApi
  class PotentialRenterProblem < Address
    attr_accessor :violations

    def initialize(params)
      super(params)
      @violations = []
    end

    def add_violation(violation)
      @violations << violation
    end

    def properties 
      {
        "color" => '#ffffff'
      }
    end

    def disclosure_attributes
      title = "<h3 class='info-window-header'>Potential Renter Problem: </h3>&nbsp;<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'>Source</a>"
      full_address = "#{@street_address.titleize}<br/>#{@city.try(&:titleize)} #{@state}, #{@census_zip}"
      owner_address = "<address>#{@county_owner_address}<br/>#{@county_owner_city} #{@county_owner_state}, #{@county_owner_zip}</address>"

      [
        title,
        "<address>#{full_address}</address>",
        "<b>Owner</b>",
        @county_owner,
        owner_address,
        '<b>Violations</b>'
      ] + violations.map(&:violation_description)
    end
  end
end