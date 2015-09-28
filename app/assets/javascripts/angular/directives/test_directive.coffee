angular.module('receta').directive 'myDirective', [ ->
  {
    restrict: 'A'
    scope: myDirectiveWatch: '='
    compile: ->
      { post: (scope, element, attributes) ->
        scope.$watch 'myDirectiveWatch', (newVal, oldVal) ->
          L.mapbox.accessToken = 'pk.eyJ1IjoiemFjaGZsYW5kZXJzIiwiYSI6Im5PQWUydWMifQ.K3IgstPvVhP6ZDoXsKNzJQ';

          if oldVal.map
            newVal.map = oldVal.map
            console.log newVal.map
            newVal.map.eachLayer (layer) ->
              console.log(layer)
          else
            newVal.map = L.mapbox.map('neighborhood-map', 'mapbox.light')

          newVal.map.setView(
            [
              newVal.coordinates[0].longtitude,
              newVal.coordinates[0].latitude
            ],
          14)

          latitudeLines = ([coord.longtitude, coord.latitude] for coord in newVal.coordinates)
          polylineOptions = {color: '#000', fillColor: '#000', fillOpacity: 0.1}
          L.polyline(latitudeLines, polylineOptions).addTo(newVal.map);

          return
        return
      }

  }
 ]