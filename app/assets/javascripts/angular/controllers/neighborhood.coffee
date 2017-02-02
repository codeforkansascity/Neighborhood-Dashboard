angular
  .module('neighborhoodstat')
  .controller("NeighborhoodCtrl",
    [
      '$scope',
      '$resource',
      '$stateParams',
      '$location',
      '$http',
      'Flash',
      ($scope, $resource, $stateParams, $location, $http, Flash)->
        Neighborhood = $resource(
          '/api/neighborhood/:neighborhoodId',
          {neighborhoodId: "@id", format: 'json'},
          {
            index:   { method: 'GET', isArray: true, responseType: 'json' },
            show:    { method: 'GET', responseType: 'json' },
            update:  { method: 'PUT', responseType: 'json' }
          }
        )

        $scope.showSearch = false;

        $scope.neighborhoodSearch = (search) ->
          if !$scope.searchingNeighborhood
            $scope.searchingNeighborhood = true

            Neighborhood.get(
              {neighborhoodId: 'locate', search_address: search.queryAddress},
              (neighborhood) ->
                $("#neighborhood-search-modal").modal('hide')
                $location.path("/neighborhood/#{neighborhood.id}/crime")
                $('body').removeClass('modal-open')
                $('.modal-backdrop').remove()
                $scope.searchingNeighborhood = false
                $('.modal-open').removeClass('modal-open')
              (code)->
                Flash.create('danger', 'Neighborhood Not Found', 5000)
                $scope.searchingNeighborhood = false
            )

        if $stateParams.neighborhoodId
          Neighborhood.get(
            {neighborhoodId: $stateParams.neighborhoodId},
            (neighborhood)->
              $scope.neighborhood = neighborhood
          )

        getPolygonCenter = (coordinates) ->
          latitude = 0
          longtitude = 0
          coordinatesSize = coordinates.length

          coordinates.forEach (coordinate) ->
            latitude += coordinate.lat()
            longtitude += coordinate.lng()

          return new google.maps.LatLng(latitude / coordinatesSize, longtitude / coordinatesSize)
    ]
  )
