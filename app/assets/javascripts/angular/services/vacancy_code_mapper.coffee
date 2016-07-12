angular
  .module('neighborhoodstat')
  .constant('VACANT_CODES', {
    LEGALLY_ABANDONED: {
      
    },
    VACANT_INDICATOR: {
      OPEN_THREE_ELEVEN: 'open',
      VACANT_REGISTRATION_FAILURE: 'vacant_registration_failure',
      VACANT_STRUCTURE: 'vacant_structure',
      ALL_PROPERTY_VIOLATIONS: 'all_property_violations',
      REGISTERED_VACANT: 'registered_vacant',
      ALL_VACANT_LOTS: 'all_vacant_filters',
      DEMO_NEEDED: 'demo_needed',
      FORECLOSED: 'foreclosed'
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
