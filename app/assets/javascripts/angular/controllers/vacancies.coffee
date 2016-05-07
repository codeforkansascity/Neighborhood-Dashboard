angular.module('neighborhoodstat').controller("VacanciesCtrl", [
  '$scope',
  '$resource',
  '$stateParams',
  '$http',
  'VacancyCodeMapper',
  ($scope, $resource, $stateParams, $http, VacancyCodeMapper)->
    $scope.filterVacantData= (vacantFilters) ->
      vacantCodes = VacancyCodeMapper.createVacantMapping(vacantFilters.codes)

      if vacantCodes.length > 0
        $http
          .get(Routes.api_neighborhood_vacancy_index_path($stateParams.neighborhoodId, vacant_codes: vacantCodes))
          .then(
            (response) ->
              clearVacancyDataMarkers()

              $scope.neighborhood.vacantDataMarkers =
                $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: response.data})

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
