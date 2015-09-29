angular.module('neighborhoodstat').directive 'myDirective', [ ->
  {
    restrict: 'A'
    scope: myDirectiveWatch: '='
    compile: ->
      { post: (scope, element, attributes) ->
        scope.$watch 'myDirectiveWatch', (newNeighborhood, oldNeighborhood) ->
          L.mapbox.accessToken = 'pk.eyJ1IjoiemFjaGZsYW5kZXJzIiwiYSI6Im5PQWUydWMifQ.K3IgstPvVhP6ZDoXsKNzJQ';

          if oldNeighborhood.map
            newNeighborhood.map = oldNeighborhood.map
            newNeighborhood.map.removeLayer(oldNeighborhood.coordinatesLayer)
          else
            newNeighborhood.map = L.mapbox.map('neighborhood-map', 'mapbox.light')

          newNeighborhood.map.setView(
            [
              newNeighborhood.coordinates[0].longtitude,
              newNeighborhood.coordinates[0].latitude
            ],
          14)

          latitudeLines = ([coord.longtitude, coord.latitude] for coord in newNeighborhood.coordinates)
          polylineOptions = {color: '#000', fillColor: '#000', fillOpacity: 0.1}
          newNeighborhood.coordinatesLayer = L.polyline(latitudeLines, polylineOptions).addTo(newNeighborhood.map)

          return
        return
      }

  }
 ]
