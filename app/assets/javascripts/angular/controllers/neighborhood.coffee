angular.module('receta').controller("NeighborhoodCtrl", [
  '$scope',
  '$http',
  ($scope, $http)->
    $scope.neighborhoodSearch = (search) ->
      response = $http.get Routes.neighborhood_index_path(search: search.query)

      response.success (data, status, headers, config) ->
        $scope.neighborhoodCoordinates = ([coordinate.longtitude, coordinate.latitude] for coordinate in data.coordinates)
        $scope.neighborhood = data;
])