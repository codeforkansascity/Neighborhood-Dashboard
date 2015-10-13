angular.module('neighborhoodstat').controller("NeighborhoodCtrl",
  [
    '$scope',
    '$resource',
    '$routeParams',
    '$location',
    '$http',
    ($scope, $resource, $routeParams, $location, $http)->
      Neighborhood = $resource('/neighborhood/:neighborhoodId', {neighborhoodId: "@id", format: 'json'})

      $scope.neighborhoodSearch = (search) ->
        Neighborhood.get(
          search: search.query,
          (neighborhood)->
            $location.path("/neighborhood/#{neighborhood.id}")
        )

      if $routeParams.neighborhoodId
        Neighborhood.get(
          {neighborhoodId: $routeParams.neighborhoodId},
          (neighborhood)->
            $scope.neighborhood = neighborhood
            $scope.neighborhoodCoordinates = ([coordinate.longtitude, coordinate.latitude] for coordinate in neighborhood.coordinates)
            $location.path("/neighborhood/#{neighborhood.id}")
        )
  ]
)
