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
        )
])
