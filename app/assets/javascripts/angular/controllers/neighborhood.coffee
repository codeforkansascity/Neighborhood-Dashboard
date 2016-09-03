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
      'Flash',
      ($scope, $resource, $stateParams, $location, $http, IMAGES, Flash)->
        Neighborhood = $resource('/api/neighborhood/:neighborhoodId', {neighborhoodId: "@id", format: 'json'})
        $scope.IMAGES = IMAGES;

        $scope.neighborhoodSearch = (search) ->
          if !$scope.searchingNeighborhood
            $scope.searchingNeighborhood = true

            Neighborhood.get(
              {neighborhoodId: 'locate', search_address: search.queryAddress},
              (neighborhood) ->
                $location.path("/neighborhood/#{neighborhood.id}/crime")
                $scope.searchingNeighborhood = false
              (code)->
                Flash.create('danger', 'Neighborhood Not Found', 5000)
                $scope.searchingNeighborhood = false
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
