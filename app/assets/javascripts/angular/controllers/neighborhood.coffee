angular
  .module('neighborhoodstat')
  .constant('IMAGES', imagePaths)
  .controller("NeighborhoodCtrl",
    [
      '$scope',
      '$resource',
      '$stateParams',
      '$location',
      '$http',
      'IMAGES',
      ($scope, $resource, $stateParams, $location, $http, IMAGES)->
        Neighborhood = $resource('/api/neighborhood/:neighborhoodId', {neighborhoodId: "@id", format: 'json'})
        $scope.IMAGES = IMAGES;

        $scope.neighborhoodSearch = (search) ->
          Neighborhood.get(
            search_neighborhood: search.queryNeighborhood,
            search_address: search.queryAddress,
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
