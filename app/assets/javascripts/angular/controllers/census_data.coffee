angular.module('neighborhoodstat').controller("CensusDataCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http'
  ($scope, $resource, $stateParams, $http)->
    $scope.housingIncomeKeys = 
      [
        {"key": 'households_with_income_less_than_$10_000', "title": 'Households With Income Less Than $10,000'},
        {"key": 'households_with_income_$10_000_$19_999', "title": 'Households With Income $10,000 - $19,999'},
        {"key": 'households_with_income_$20_000_$29_999', "title": 'Households With Income $20,000 - $29,999'},
        {"key": 'households_with_income_$30_000_$39_999', "title": 'Households With Income $30,000 - $39,999'},
        {"key": 'households_with_income_$40_000_$49_999', "title": 'Households With Income $40,000 - $49,999'},
        {"key": 'households_with_income_$50_000_$59_999', "title": 'Households With Income $50,000 - $59,999'},
        {"key": 'households_with_income_$60_000_$74_999', "title": 'Households With Income $60,000 - $74,999'},
        {"key": 'households_with_income_$75_000_$99_999', "title": 'Households With Income $75,000 - $99,999'},
        {"key": 'households_with_income_$100_000_$124_999', "title": 'Households With Income $100,000 - $124,999'},
        {"key": 'households_with_income_$125_000_$149_999', "title": 'Households With Income $125,000 - $149,999'},
        {"key": 'households_with_income_$150_000_$199_999', "title": 'Households With Income $150,000 - $199,999'},
        {"key": 'households_with_income_$200_000_or_more', "title": 'Households With Income $200,000 or More'},
        {"key":'households_with_income_from_interest__dividends_or_rent', "title": 'Households With Income From Interest or Dividends'},
        {"key":'households_with_income_from_public_assistance', "title": 'Households With Income From Public Assistance'},
        {"key":'households_with_income_from_social_security', "title": 'Households With Income From Social Security'}
      ]

    $http
        .get(Routes.api_neighborhood_census_data_path($stateParams.neighborhoodId))
        .then(
          (response) ->
            $scope.censusDataStatistics = response.data
            console.log response.data.average_city_totals
            $scope.averageCensusStatistics = response.data.average_city_totals
        )
])
