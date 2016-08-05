angular
  .module('neighborhoodstat')
  .constant('VACANT_CODES', {
    LEGALLY_ABANDONED: {
      ONE_THREE_YEARS: 'one_three_years_violation_length',
      THREE_YEARS_PLUS: 'three_years_plus_violation_length',
      BOARDED_LONGTERM: 'boarded_longterm',
      VACANT_REGISTRY_FAILURE: 'vacant_registry_failure',
      DANGEROUS_BUILDING: 'dangerous_building'
    },
    VACANT_INDICATOR: {
      OPEN_THREE_ELEVEN: 'open',
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
