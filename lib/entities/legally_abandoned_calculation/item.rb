module Entities::LegallyAbandonedCalculation
  class Item < ::Entities::GeoJson
    attr_accessor :vacant_registry_failure_data, :tax_delinquent_data, :address_violation_count, :three_eleven_data, :dangerous_buildings

    def initialize(address)
      @address = address
      @vacant_registry_failure_data = {}
      @tax_delinquent_data = {}
      @address_violation_count = {}
      @three_eleven_data = {}
      @dangerous_buildings = {}
    end

    def properties
      {
        marker_style: geometry["type"] == 'Point' ? 'circle' : nil,
        color: land_bank_color,
        total_points: total_points
      }
    end

    def disclosure_attributes
      full_address = "#{@address.titleize}<br/>#{@tax_delinquent_data[:city].try(&:titleize)} #{@tax_delinquent_data[:state]}, #{@tax_delinquent_data[:zip]}"

      [
        '<h3 class="info-window-header">Address</h3>',
        "<address>#{full_address}</address>",
        '<h3 class="info-window-header">Owner</h3>',
        @tax_delinquent_data[:owner] || 'Not Available',
        three_eleven_disclosure_attributes,
        dangerous_buildings_disclosure_attributes,
        vacant_registry_disclosure_attributes,
        tax_delinquent_disclosure_attributes,
        code_violation_disclosure_attributes
      ].flatten.uniq
    end

    def legally_abandoned?
      @address_violation_count.present? && 
      @tax_delinquent_data.present? && 
      (@vacant_registry_failure_data.present? || @dangerous_buildings.present? || @three_eleven_data.present?) && 
      total_points >= 4
    end

    # Gets the total vacancy indication of the property
    #
    # The formula for this goes as follows
    # - Vacancy indication is determined by a point range going from 0 to 6
    # - If the address is a dangerous building, has a vacant registry failure, or three eleven data present, it gets 2 points
    # - For tax delinquency data, 0 consecutive years is 0 points, 1-3 years is 1 point, and 3+ is 2 points
    # - For code violation count at the address, 0 violations is 0 points, 1-3 violations is 1 point, and 3+ is 2 points
    def total_points
      current_points = 0

      if @dangerous_buildings.present? || 
         @vacant_registry_failure_data.present? || 
         (@three_eleven_data.present? && @three_eleven_data[:violations].size > 0)
        current_points = 2
      end

      case 
      when @tax_delinquent_data.nil? || @tax_delinquent_data[:consecutive_years].nil?
        current_points += 0
      when @tax_delinquent_data[:consecutive_years] >= 3
        current_points += 2
      when @tax_delinquent_data[:consecutive_years].to_i > 0
        current_points += 1
      end

      case 
      when @address_violation_count.nil? || @address_violation_count[:violation_count].nil?
        current_points += 0
      when @address_violation_count[:violation_count] >= 3
        current_points += 2
      when @address_violation_count[:violation_count].to_i > 0
        current_points += 1
      end

      current_points
    end

    def geometry
      parcel_coordinates = StaticData.PARCEL_DATA().each_with_object({}) do |parcel, hash|
        hash[parcel['properties']['land_ban60'].split("\n")[0].downcase] = parcel['geometry']['coordinates'][0]
      end

      if parcel_coordinates[@address.downcase].present?
        {
          "type" => "Polygon",
          "coordinates" => parcel_coordinates[@address.downcase]
        }
      else
        {
          "type" => "Point",
          "coordinates" => [@three_eleven_data[:longitude].to_f, @three_eleven_data[:latitude].to_f]
        }
      end
    end

    def latitude
      @three_eleven_data[:latitude]
    end

    def longitude
      @three_eleven_data[:longitude]
    end

    private

    def code_violation_disclosure_attributes
      return [] unless @address_violation_count.present?

      source_link = "<a href='#{KcmoDatasets::DangerousBuildings::SOURCE_URI}'><small>(Source)</small></a>"

      [
        "<h2 class='info-window-header'>Code Violation Count</h2>&nbsp;#{source_link}",
        "#{@address_violation_count[:violation_count]} Code Violations"
      ]
    end

    def dangerous_buildings_disclosure_attributes
      return [] unless @dangerous_buildings.present?

      source_link = "<a href='#{KcmoDatasets::DangerousBuildings::SOURCE_URI}'><small>(Source)</small></a>"

      [
        "<h2 class='info-window-header'>Dangerous Building</h2>&nbsp;#{source_link}",
        "Last Updated: #{@dangerous_buildings[:last_updated_date]}",
        @dangerous_buildings[:statusofcase]
      ]
    end

    def three_eleven_disclosure_attributes
      return [] unless @three_eleven_data.present?

      source_link = "<a href='#{KcmoDatasets::ThreeElevenCases::SOURCE_URI}' target='_blank'><small>(Source)</small></a>"

      [
        "<h2 class='info-window-header'>311 Complaints</h2>&nbsp;#{source_link}",
        "Last Updated: #{@three_eleven_data[:last_updated_date]}",
        @three_eleven_data[:violations]
      ].flatten
    end

    def tax_delinquent_disclosure_attributes
      return [] unless @tax_delinquent_data.present?

      [
        "<h2 class='info-window-header'>Tax Delinquency</h2>&nbsp;<a href='#{@tax_delinquent_data[:source]}'><small>(Source)</small></a>",
        "#{@tax_delinquent_data[:consecutive_years]} year(s) Tax Delinquent"
      ]
    end

    def vacant_registry_disclosure_attributes
      return [] unless @vacant_registry_failure_data.present?
      source_link = "<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'><small>(Source)</small></a>"

      [
        "<h2 class='info-window-header'>Property Violations</h2>&nbsp;#{source_link}",
        "Last Updated: #{@vacant_registry_failure_data[:last_updated_date]}",
        @vacant_registry_failure_data[:violation_description]
      ]
    end

    def land_bank_color
      case total_points
      when 6 then '#000'
      when 5 then '#444'
      when 4 then '#888'
      when 3 then '#CCC'
      end
    end
  end
end