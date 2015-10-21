angular.module('neighborhoodstat').controller("NeighborhoodCtrl",
  [
    '$scope',
    '$resource',
    '$stateParams',
    '$location',
    '$http',
    ($scope, $resource, $stateParams, $location, $http)->
      Neighborhood = $resource('/neighborhood/:neighborhoodId', {neighborhoodId: "@id", format: 'json'})

      $scope.neighborhoodSearch = (search) ->
        Neighborhood.get(
          search: search.query,
          (neighborhood)->
            $location.path("/neighborhood/#{neighborhood.id}/crime")
        )

      if $stateParams.neighborhoodId
        Neighborhood.get(
          {neighborhoodId: $stateParams.neighborhoodId},
          (neighborhood)->
            $scope.neighborhood = neighborhood
            $scope.neighborhoodCoordinates = ([coordinate.longtitude, coordinate.latitude] for coordinate in neighborhood.coordinates)
        )
  ]
)
