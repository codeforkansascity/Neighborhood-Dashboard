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
        $scope.showSearch = false;

        $scope.neighborhoodSearch = (search) ->
          if !$scope.searchingNeighborhood
            $scope.searchingNeighborhood = true

            Neighborhood.get(
              {neighborhoodId: 'locate', search_address: search.queryAddress},
              (neighborhood) ->
                $("#neighborhood-search-modal").modal('hide')
                $location.path("/neighborhood/#{neighborhood.id}/crime")
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
                  strokeColor: '#666',
                  fillColor: '#000',
                  fillOpacity: 0.2,
                  strokeWidth: '0.5px'
                }
              )
              neighborhoodLayer.setMap($scope.map)
              neighborhoodLayer.addListener 'mouseover', displayNeighborhoodTooltip(neighborhood)

              neighborhoodLayer.addListener 'mouseover', (e) ->
                this.setOptions({fillOpacity: 0.4})

              neighborhoodLayer.addListener 'mouseout', (e) ->
                this.setOptions({fillOpacity: 0.2})

        displayNeighborhoodTooltip = (neighborhood) ->
          return (e) ->
            $scope.cityInfoWindow.setPosition(getPolygonCenter(this.getPath()))
            $scope.cityInfoWindow.setOptions({pixelOffset: new google.maps.Size(0, 0)})
            $scope.cityInfoWindow.setContent(
              '<p>' + neighborhood.name + '</p>' +
              '<a class="btn btn-primary" ui-sref="neighborhood.crime.detail({neighborhoodId: neighborhood.id})" href="/neighborhood/' + neighborhood.id + '/vacancies">Go to Neighborhood</a>'
            )
            $scope.cityInfoWindow.open($scope.map)

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
