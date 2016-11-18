angular.module('neighborhoodstat').controller("VacanciesCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http',
  'VacancyCodeMapper',
  'StackedMarkerMapper',
  ($scope, $resource, $stateParams, $http, VacancyCodeMapper, StackedMarkerMapper)->
    $scope.filterVacantData= (vacantFilters) ->
      vacantCodes = VacancyCodeMapper.createVacantMapping(vacantFilters.codes)

      if vacantCodes.length > 0
        startDate = vacantFilters.startDate
        endDate = vacantFilters.endDate

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
              geoJSONData = StackedMarkerMapper.createStackedMarkerDataSet(response.data)

              debugger
              $scope.neighborhood.vacantDataMarkers =
                $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: geoJSONData})

              $scope.activateFilters = false
          )
      else
        clearData()
        removeLegend()
        $scope.activateFilters = false

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
