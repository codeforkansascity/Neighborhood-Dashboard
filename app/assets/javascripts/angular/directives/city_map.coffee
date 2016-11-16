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

      $scope.cityInfoWindow = new google.maps.InfoWindow();
  }
)
