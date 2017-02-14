angular.module('neighborhoodstat').controller("VacanciesCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http',
  'VacancyCodeMapper',
  'StackedMarkerMapper',
  ($scope, $resource, $stateParams, $http, VacancyCodeMapper, StackedMarkerMapper)->
    $scope.isQueryingFilters = false

    $scope.filterVacantData= (vacantFilters) ->
      vacantCodes = VacancyCodeMapper.createVacantMapping(vacantFilters.codes)

      if vacantCodes.length > 0
        startDate = vacantFilters.startDate
        endDate = vacantFilters.endDate
        $scope.isQueryingFilters = true

        $http
          .get(
            Routes.api_neighborhood_vacancy_index_path(
              $stateParams.neighborhoodId,
              filters: vacantCodes,
              start_date: startDate,
              end_date: endDate
            )
          )
          .then(
            (response) ->
              clearData()
              removeLegend()
              drawLegend()
              geoJSONData = StackedMarkerMapper.createStackedMarkerDataSet(response.data)

              $scope.neighborhood.vacantDataMarkers =
                $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: geoJSONData})
          )
          .finally(
            () ->
              $scope.isQueryingFilters = false
              $scope.activateFilters = false
          )
      else
        clearData()
        removeLegend()
        $scope.activateFilters = false

    $scope.disabledLegallyAbandoned= () ->
      if $scope.vacantFilters
        for k, v of $scope.vacantFilters.codes.VACANT_INDICATOR
          if v
            return true

      return false

    $scope.disabledVacantFilters= () ->
      return $scope.vacantFilters &&
             $scope.vacantFilters.codes.LEGALLY_ABANDONED.ALL_ABANDONED

    drawLegend= ()->
        # Don't draw the legend if it already exist
        return if $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].b &&
                  $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].b[0]

        legendMarkup =
          $("<nav class='legend clearfix'>" +
            '<ul>' +
              '<li>' +
                '<span class="legend-element" style="background-color: #CCC;"></span>Low Indication of Vacancy' +
              '</li>' +
              '<li>' +
                '<span class="legend-element" style="background-color: #888;"></span>Medium Indication of Vacancy' +
              '</li>' +
              '<li>' +
                '<span class="legend-element" style="background-color: #444;"></span>High Indication of Vacancy' +
              '</li>' +
              '<li>' +
                '<span class="legend-element" style="border: #000 solid 1px; background-color: #000;"></span>Very High Indication of Vacancy' +
              '</li>' +
            '</ul>' +
            '<ul>' +
              '<li>' +
              'Circle - Vacant Building' +
              '</li>' +
              '<li>' +
              'Polygon - Vacant Lot' +
              '</li>' +
            '</ul>' +
          '</nav>');

        $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(legendMarkup.get(0))

    removeLegend= ()->
      # We only want to remove the legend if it exists
      return if !$scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].b ||
                !$scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].b[0]

      $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].pop()

    clearData= ()->
      if $scope.neighborhood.map.data
        $scope.neighborhood.map.data.forEach((feature) ->
          $scope.neighborhood.map.data.remove(feature)
        )
])
