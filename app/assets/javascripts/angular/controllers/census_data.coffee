angular.module('neighborhoodstat').controller("CensusDataCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http'
  ($scope, $resource, $stateParams, $http)->
    $http
        .get(Routes.api_neighborhood_census_data_path($stateParams.neighborhoodId))
        .then(
          (response) ->
            $scope.censusDataStatistics = response.data
            console.log(response.data)
            console.log('Owner Numbers')
            console.log(response.data.owner_occupied_housing_units)
        )
])
