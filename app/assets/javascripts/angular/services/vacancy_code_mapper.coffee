angular
  .module('neighborhoodstat')
  .constant('VACANT_CODES', {
    LEGALLY_ABANDONED: {
      DEMO_NEEDED: 'demo_needed',
      FORECLOSED: 'foreclosed'
    },
    VACANT_INDICATORS: {

    }
  })  
  .service('VacancyCodeMapper', [
    'VACANT_CODES',
    (VACANT_CODES) ->
      createVacantMapping: (vacantCodes) ->
        apiVacantCodes = []

        for i, j of vacantCodes
          for k, l of j
            if vacantCodes[i][k]
              apiVacantCodes.push(VACANT_CODES[i][k])

        return apiVacantCodes
  ])
