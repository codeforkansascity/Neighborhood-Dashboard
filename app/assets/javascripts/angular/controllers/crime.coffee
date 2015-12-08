
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
          .get(Routes.neighborhood_crime_index_path($stateParams.neighborhoodId, {crime_codes: fbiCodes}))
          .then(
            (response) ->
              L.mapbox.featureLayer()
                .setGeoJSON(response.data)
                .addTo($scope.neighborhood.map)

              $scope.activateFilters = false
          )

      $http
        .get(Routes.grouped_totals_neighborhood_crime_index_path($stateParams.neighborhoodId))
        .then(
          (response) ->
            $scope.crimeStatistics = response.data
        )

      $scope.calculateCategoryTotals = (category) ->
        if($scope.crimeStatistics)
          crimes = $scope.crimeStatistics[category]

          # switch category
          #   when 'PERSON'
          #     return crimes.ASSAULT_AGGRAVATED +
          #            crimes.ASSAULT_SIMPLE +
          #            crimes.ASSAULT_INTIMIDATION +
          #            crimes.HOMICIDE_NONNEGLIGENT_MANSLAUGHTER +
          #            crimes.HOMICIDE_NEGLIGENT_MANSLAUGHETER +
          #            crimes.SEX_OFFENSE_RAPE +
          #            crimes.SEX_OFFENSE_SODOMY +
          #            crimes.SEX_OFFENSE_ASSAULT_WITH_OBJECT +
          #            crimes.SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE +
          #            crimes.SEX_OFFENSE_NONFORCIBLE_INCEST +
          #            crimes.SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE
          #   else
          #     return 0

          # This is code that will get the count of all crimes in the category. If we can display
          # every crime inside the table, then we can use this code.
          return (count for code, count of $scope.crimeStatistics[category]).reduce (a,b) -> a + b
        else
          return 0
  ])
