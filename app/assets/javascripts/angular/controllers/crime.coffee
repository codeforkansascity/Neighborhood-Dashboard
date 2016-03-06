angular
  .module('neighborhoodstat')
  .controller("CrimeCtrl", [
    '$scope',
    '$resource',
    '$http',
    '$stateParams',
    'CrimeCodeMapper',
    ($scope, $resource, $http, $stateParams, CrimeCodeMapper)->
      $scope.visible = true

      $scope.clearFilters = (crimeCodes) ->
        for key, val of crimeCodes
          crimeCodes[key] = false

      $scope.getCrimeByCodes = (crimeCodes) ->
        fbiCodes = []
        for key, val of crimeCodes
          if val
            fbiCodes.push(key)

        fbiCodes = CrimeCodeMapper.createFBIMapping(fbiCodes)

        if fbiCodes.length > 0
          $http
            .get(Routes.api_neighborhood_crime_index_path($stateParams.neighborhoodId, {crime_codes: fbiCodes}))
            .then(
              (response) ->
                clearCrimeMarkers()

                $scope.neighborhood.crimeMarkers =
                  $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: response.data})

                $scope.activateFilters = false

                if response.data.length == 0
                  removeLegend()
                else
                  drawLegend()
            )
        else
          clearCrimeMarkers()
          removeLegend()
          $scope.activateFilters = false

      $http
        .get(Routes.grouped_totals_api_neighborhood_crime_index_path($stateParams.neighborhoodId))
        .then(
          (response) ->
            $scope.crimeStatistics = response.data
        )

      $scope.calculateCategoryTotals = (category) ->
        if($scope.crimeStatistics)
          return (count for code, count of $scope.crimeStatistics[category]).reduce (a,b) -> a + b
        else
          return 0

      drawLegend= ()->
        # Don't draw the legend if it already exist
        return if $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].j[0]

        legendMarkup =
          $("<nav class='legend clearfix'>" +
            '<ul>' +
              '<li>' +
                '<span class="legend-element" style="background-color: #626AB2;"></span>Person' +
              '</li>' +
              '<li>' +
                '<span class="legend-element" style="background-color: #313945;"></span>Property' +
              '</li>' +
              '<li>' +
                '<span class="legend-element" style="background-color: #6B7D96;"></span>Society' +
              '</li>' +
              '<li>' +
                '<span class="legend-element" style="border: #000 solid 1px; background-color: #FFFFFF;"></span>Uncategorized' +
              '</li>' +
            '</ul>' +
          '</nav>');

        $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(legendMarkup.get(0))

      removeLegend= ()->
        # We only want to remove the legend if it exists
        return if !$scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].j[0]
        $scope.neighborhood.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].pop()

      clearCrimeMarkers= ()->
        if $scope.neighborhood.crimeMarkers
          $scope.neighborhood.map.data.forEach((feature) ->
            $scope.neighborhood.map.data.remove(feature)
          )

          $scope.neighborhood.crimeMarkers = null
  ])
