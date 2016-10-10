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
        Neighborhood = $resource(
          '/api/neighborhood/:neighborhoodId', 
          {neighborhoodId: "@id", format: 'json'},
          {
            index:   { method: 'GET', isArray: true, responseType: 'json' },
            show:    { method: 'GET', responseType: 'json' },
            update:  { method: 'PUT', responseType: 'json' }
          }
        )

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
          )
        else
          Neighborhood.index(
            {},
            (neighborhoods)->
              populateNeighborhoodMap(neighborhoods)
          )

        populateNeighborhoodMap = (neighborhoods) ->
          for neighborhood in neighborhoods 
            do (neighborhood) ->
              latitudeLines = ({lat: coord.latitude, lng: coord.longtitude} for coord in neighborhood.coordinates)
              neighborhoodLayer = new google.maps.Polygon(
                {
                  paths: latitudeLines,
                  strokeColor: '#000',
                  fillColor: '#000',
                  fillOpacity: 0.1
                }
              )

              neighborhoodLayer.setMap($scope.map)
              neighborhoodLayer.addListener 'click', (e) ->
                $scope.cityInfoWindow.setPosition(getPolygonCenter(this.getPath()));
                $scope.cityInfoWindow.setOptions({pixelOffset: new google.maps.Size(0, 0)});

        getPolygonCenter = (coordinates) ->
          latitude = 0
          longtitude = 0
          coordinatesSize = 0

          console.log(coordinates.length)

          coordinates.forEach (path) ->
            console.log(path)
            coordinatesSize = path.getArray().length

            path.getArray().forEach (latLng) ->
              latitude += latLng.lat()
              longtitude += latLng.lng()

          return new google.maps.LatLng(latitude / coordinatesSize, longtitude / coordinatesSize)
    ]
  )
