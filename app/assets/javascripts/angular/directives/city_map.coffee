angular.module('neighborhoodstat').directive('cityMap', () ->
  return {
    link: ($scope, element, attrs)->
      element.attr('id', 'city-map');
      element.attr('style', 'position: absolute; top: 0; bottom: 0; width: 100%; height: 100%;');

      $scope.map = new google.maps.Map(
        document.getElementById('city-map'),
        {
          center: new google.maps.LatLng(39.0997, -94.5786),
          zoom: 14
        }
      )

      $scope.map.data.loadGeoJson('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON',{}, (data) ->
        data.forEach (data) ->
          if !data.getProperty('nbhname')
            $scope.map.data.remove(data)
      )

      $scope.map.data.addListener 'mouseover', (e) ->
        neighborhood = e.feature
        $scope.cityInfoWindow.setPosition(getPolygonCenter(neighborhood.getGeometry()))
        $scope.cityInfoWindow.setOptions({pixelOffset: new google.maps.Size(0, 0)})
        $scope.cityInfoWindow.setContent(
          '<p>' + neighborhood.getProperty('nbhname') + '</p>' +
          '<a class="btn btn-primary" ui-sref="neighborhood.crime.detail({neighborhoodId: neighborhood.getProperty("nbhid")})" href="/neighborhood/' + neighborhood.getProperty('nbhid') + '/vacancies">Go to Neighborhood</a>'
        )
        $scope.cityInfoWindow.open($scope.map)

      $scope.map.data.addListener 'mouseout', (e) ->
        this.setOptions({fillOpacity: 0.2})

      $scope.cityInfoWindow = new google.maps.InfoWindow();

      getPolygonCenter = (geometry) ->
        latitude = 0
        longtitude = 0
        coordinatesSize = 0

        geometry.forEachLatLng (coord) ->
          coordinatesSize += 1
          latitude += coord.lat()
          longtitude += coord.lng()

        return new google.maps.LatLng(latitude / coordinatesSize, longtitude / coordinatesSize)
  }
)
