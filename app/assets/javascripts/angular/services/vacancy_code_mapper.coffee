angular
  .module('neighborhoodstat')
  .constant('VACANT_CODES', {
    LEGALLY_ABANDONED: {
      DEMO_NEEDED: 'demo_needed',
      FORECLOSED: 'foreclosed'
    },
    VACANT_INDICATOR: {
      OPEN_THREE_ELEVEN: 'open',
      VACANT_REGISTRATION_FAILURE: 'vacant_registration_failure',
      VACANT_STRUCTURE: 'vacant_structure'
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
