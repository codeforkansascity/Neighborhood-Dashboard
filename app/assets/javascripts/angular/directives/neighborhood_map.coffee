angular.module('neighborhoodstat').directive('neighborhoodMap', () ->
  return {
    link: ($scope, element, attrs)->
      element.attr('id', 'neighborhood-map');
      element.attr('class', 'tab-pane active');

      $scope.neighborhood.map = new google.maps.Map(
        document.getElementById('neighborhood-map'),
        {
          center: new google.maps.LatLng($scope.neighborhood.coordinates[0].latitude, $scope.neighborhood.coordinates[0].longtitude),
          zoom: 14
        }
      )

      latitudeLines = ({lat: coord.latitude, lng: coord.longtitude} for coord in $scope.neighborhood.coordinates)
      $scope.neighborhood.coordinatesLayer = new google.maps.Polygon(
        {
          paths: latitudeLines,
          strokeColor: '#000',
          fillColor: '#000',
          fillOpacity: 0.1
        }
      )

      $scope.neighborhood.coordinatesLayer.setMap($scope.neighborhood.map)
      $scope.mapInfoWindow = new google.maps.InfoWindow();

      $scope.neighborhood.map.data.addListener('click', (e) ->
        if e.feature.getGeometry().getType() == 'Point'
          $scope.mapInfoWindow.setPosition(e.feature.getGeometry().get());
          $scope.mapInfoWindow.setOptions({pixelOffset: new google.maps.Size(0, -30)});

        if e.feature.getGeometry().getType() == 'Polygon'
          $scope.mapInfoWindow.setPosition(getPolygonCenter(e.feature.getGeometry().getArray()));
          $scope.mapInfoWindow.setOptions({pixelOffset: new google.maps.Size(0, 0)});
          
        $scope.mapInfoWindow.setContent(outputDisclosureAttributes(e.feature.getProperty('disclosure_attributes')));
        $scope.mapInfoWindow.open($scope.neighborhood.map);
      )

      $scope.neighborhood.map.data.setStyle((feature) ->
        if feature.getGeometry().getType() == 'Point'
          return {
            icon: drawMapMarker(feature.getProperty('color'))
          }

        if feature.getGeometry().getType() == 'Polygon'
          return {
            fillColor: feature.getProperty('color'),
            strokeColor: feature.getProperty('color')
          }
      )

      getPolygonCenter = (coordinates) ->
        latitude = 0
        longtitude = 0
        coordinatesSize = 0

        coordinates.forEach (path) ->
          coordinatesSize = path.getArray().length

          path.getArray().forEach (latLng) ->
            latitude += latLng.lat()
            longtitude += latLng.lng()

        return new google.maps.LatLng(latitude / coordinatesSize, longtitude / coordinatesSize)

      outputDisclosureAttributes = (disclosureAttributes) ->
        return disclosureAttributes.join('<br/>')

      drawMapMarker = (color) ->
        return {
          path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z M -2,-30 a 2,2 0 1,1 4,0 2,2 0 1,1 -4,0',
          fillColor: color,
          fillOpacity: 1,
          strokeColor: '#000',
          strokeWeight: 2,
          scale: 1,
        }
  }
)
