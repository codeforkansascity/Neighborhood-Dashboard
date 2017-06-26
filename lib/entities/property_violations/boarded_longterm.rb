module Entities::PropertyViolations
  class BoardedLongterm < Violation
    attr_accessor :status, :violation_description, :address, :mapping_location

    def disclosure_attributes
      [
        'Boarded and Vacant Over 150 Days'
      ]
    end
  end
end
