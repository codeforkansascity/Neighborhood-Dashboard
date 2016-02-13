angular
  .module('neighborhoodstat')
  .constant('CRIME_CODES', {
    ARSON: '200',
    ASSAULT: '13',
    ASSAULT_AGGRAVATED: '13A',
    ASSAULT_SIMPLE: '13B',
    ASSAULT_INTIMIDATION: '13C',
    BRIBERY: '510',
    BURGLARY: '220',
    COUNTERFEITING: '250',
    VANDALISM: '290',
    DRUG: '35',
    DRUG_NARCOTIC: '35A',
    EMBEZZLEMENT: '270',
    EXTORTION: '210',
    FRAUD: '26',
    FRAUD_SWINDLE: '26A'
  })
  .controller("CrimeCtrl", [
    '$scope',
    '$resource',
    '$http',
    '$stateParams',
    'CRIME_CODES',
    ($scope, $resource, $http, $stateParams, CRIME_CODES)->
      $scope.visible = true
      $scope.clearFilters = () ->
      $scope.getCrimeByCodes = (crimeCodes) ->
        selectedCrimes = (key for key, val of crimeCodes)
        fbiCodes = []
        selectedCrimes.forEach (item, index, array) ->
          switch item
            when 'ASSAULT'
              fbiCodes.push(
                CRIME_CODES.ASSAULT_AGGRAVATED,
                CRIME_CODES.ASSAULT_SIMPLE,
                CRIME_CODES.ASSAULT_INTIMIDATION
              )
            when 'DRUG'
              fbiCodes.push(
                CRIME_CODE.DRUG_NARCOTIC
              )
            else
              fbiCodes.push(CRIME_CODES[item])

        $http
          .get(Routes.api_neighborhood_crime_index_path($stateParams.neighborhoodId, {crime_codes: fbiCodes}))
          .then(
            (response) ->
              $scope.neighborhood.map.data.addGeoJson({type: 'FeatureCollection', features: response.data})
              $scope.activateFilters = false
          )

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
  ])
