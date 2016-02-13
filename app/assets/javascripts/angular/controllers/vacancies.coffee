angular.module('neighborhoodstat').controller("VacanciesCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http',
  ($scope, $resource, $stateParams, $http)->
    $http
      .get(Routes.dangerous_buildings_api_neighborhood_vacancy_path($stateParams.neighborhoodId))
      .then(
        (response) ->
          $scope.dangerousNeighborhoods = response.data
          $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: response.data})
      )

    $http
      .get(Routes.vacant_lots_api_neighborhood_vacancy_path($stateParams.neighborhoodId))
      .then(
        (response) ->
          $scope.vacantLots = response.data
          $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: response.data})

          drawLegend()
      )

    drawLegend= ()->
      legendMarkup =
        $("<nav class='legend clearfix'>" +
          '<ul>' +
            '<li>' +
              '<span class="legend-element" style="background-color: #A3F5FF;"></span>Vacant Lots' +
              '<ul>' +
                '<li>' +
                  '<span class="legend-element" style="background-color: #A3F5FF;"></span>0-1 Years Vacant' +
                '</li>' +
                '<li>' +
                  '<span class="legend-element" style="background-color: #3A46B2;"></span>1-3 Years Vacant' +
                '</li>' +
                '<li>' +
                  '<span class="legend-element" style="background-color: #000000;"></span>3+ Years Vacant' +
                '</li>' +
              '</ul>' +
            '</li>' +
            '<li><span class="legend-element" style="background-color: #f28729;"></span> Dangerous Building</li>' +
          '</ul>' +
        '</nav>');

      $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(legendMarkup.get(0))

])
