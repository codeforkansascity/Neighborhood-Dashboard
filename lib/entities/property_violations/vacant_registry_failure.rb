module Entities::PropertyViolations
  class VacantRegistryFailure < Violation
    attr_accessor :status, :violation_description

    def disclosure_attributes
      [
        'Failure to Register as Vacant'
      ]
    end
  end
end
