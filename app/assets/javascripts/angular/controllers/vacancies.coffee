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
          layer = L.mapbox.featureLayer()
            .setGeoJSON(response.data)
            .addTo($scope.neighborhood.map)
      )
])
