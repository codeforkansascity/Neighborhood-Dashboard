angular.module('neighborhoodstat').directive('neighborhoodMap', () ->
  return {
    link: ($scope, element, attrs)->
      element.attr('id', 'neighborhood-map');
      element.attr('class', 'tab-pane active');
      L.mapbox.accessToken = 'pk.eyJ1IjoiemFjaGZsYW5kZXJzIiwiYSI6Im5PQWUydWMifQ.K3IgstPvVhP6ZDoXsKNzJQ';

      $scope.neighborhood.map = L.mapbox.map('neighborhood-map', 'mapbox.light')
      $scope.neighborhood.map.setView(
        [
          $scope.neighborhood.coordinates[0].longtitude,
          $scope.neighborhood.coordinates[0].latitude
        ],
      14)

      latitudeLines = ([coord.longtitude, coord.latitude] for coord in $scope.neighborhood.coordinates)
      polylineOptions = {color: '#000', fillColor: '#000', fillOpacity: 0.1}
      $scope.neighborhood.coordinatesLayer = L.polyline(latitudeLines, polylineOptions).addTo($scope.neighborhood.map)
  }
)
