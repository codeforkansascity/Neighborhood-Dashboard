angular.module('neighborhoodstat').directive('cityMap', () ->
  return {
    link: ($scope, element, attrs)->
      element.attr('id', 'city-map');
      element.attr('style', 'min-height: 600px;');

      $scope.map = new google.maps.Map(
        document.getElementById('city-map'),
        {
          center: new google.maps.LatLng(39.0997, -94.5786),
          zoom: 10
        }
      )      

      $scope.cityInfoWindow = new google.maps.InfoWindow();
  }
)
