class NeighborhoodServices::MiscellaneousData::ProblemRenters
  POSSIBLE_FILTERS = ['problem_renters']

  def initialize(neighborhood, filters = {})
    @neighborhood = neighborhood
    @filters = filters
  end

  def data
    data = {}

    @neighborhood.addresses.each do |address|
      if address['county_owner_address'] != address['street_address']
        data[address['street_address'].downcase] = Entities::AddressApi::PotentialRenterProblem.deserialize(address)
      end
    end

    dataset = KcmoDatasets::PropertyViolations.new(@neighborhood).open_cases

    dataset.request_data.each do |violation|
      current_entity = Entities::PropertyViolations::Violation.deserialize(violation)
      current_address = data[current_entity.address.downcase]
      current_address.add_violation(current_entity) if current_address
    end

    data.values.select{ |potential_problem| potential_problem.violations.count > 0 }
  end
end
