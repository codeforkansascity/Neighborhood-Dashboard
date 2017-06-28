module Entities::ThreeEleven
  class Cases < ::Entities::MultiDatasetGeoJson
    def initialize

      attr_accessor :metadata
      def properties 
        {
          "color" => '#ffffff'
        }
      end

      def disclosure_attributes
        title = "<h3 class='info-window-header'>Property Violations:</h3>&nbsp;<a href='#{KcmoDatasets::PropertyViolations::SOURCE_URI}'>Source</a>"
        last_updated = "Last Updated Date: #{last_updated_date}"
        location_address = "<b>Address:</b>&nbsp;#{address}"
        [title, last_updated, location_address] + super
      end

      def address
        first_dataset = @datasets.first

        if first_dataset
          first_dataset.address.titleize
        else
          'N/A'
        end
      end

      def geometry
        first_dataset = @datasets.first

        if first_dataset
          first_dataset.geometry
        else
          {}
        end
      end

      def mappable?
      end

      private

      
    end
  end
end