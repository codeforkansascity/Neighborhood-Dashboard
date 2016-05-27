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
              clearVacancyDataMarkers()
              geoJSONData = StackedMarkerMapper.createStackedMarkerDataSet(response.data)

              $scope.neighborhood.vacantDataMarkers =
                $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: geoJSONData})

              $scope.activateFilters = false
          )
      else
        clearVacancyDataMarkers()
        $scope.activateFilters = false

    clearVacancyDataMarkers= ()->
      if $scope.neighborhood.vacantDataMarkers
        $scope.neighborhood.map.data.forEach((feature) ->
          $scope.neighborhood.map.data.remove(feature)
        )

        $scope.neighborhood.crimeMarkers = null

])
