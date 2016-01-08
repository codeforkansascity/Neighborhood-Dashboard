angular.module('neighborhoodstat').controller("VacanciesCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http',
  ($scope, $resource, $stateParams, $http)->
    $http
      .get(Routes.dangerous_buildings_neighborhood_vacancy_path($stateParams.neighborhoodId))
      .then(
        (response) ->
          $scope.dangerousNeighborhoods = response.data
          console.log($scope.dangerousNeighborhoods)
          console.log($scope.neighborhood.map)

          layer = L.mapbox.featureLayer()
            .setGeoJSON(response.data)
            .addTo($scope.neighborhood.map)

          console.log(layer)
      )
])
