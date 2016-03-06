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
    FORGERY: '250',
    VANDALISM: '290',
    DRUG: '35',
    DRUG_NARCOTIC: '35A',
    DRUG_EQUIPMENT: '35B',
    EMBEZZLEMENT: '270',
    EXTORTION: '210',
    FRAUD: '26',
    FRAUD_SWINDLE: '26A',
    FRAUD_CREDIT_CARD: '26B',
    FRAUD_IMPERSONATION: '26C',
    FRAUD_WELFARE: '26D',
    FRAUD_WIRE: '26E',
    GAMBLING: '39',
    GAMBLING_BETTING: '39A',
    GAMBLING_OPERATING: '39B',
    GAMBLING_EQUIPMENT_VIOLATIONS: '39C',
    GAMBLING_TAMPERING: '39D',
    HOMICIDE: '09',
    HOMICIDE_NONNEGLIGENT_MANSLAUGHTER: '09A',
    HOMICIDE_NEGLIGENT_MANSLAUGHTER: '09B',
    HUMAN_TRAFFICKING: '64',
    HUMAN_TRAFFICKING_SEX_ACTS: '64A',
    HUMAN_TRAFFICKING_INVOLUNTARY_SERVITUDE: '64B',
    KIDNAPPING: '100',
    THEFT: '23',
    THEFT_POCKET_PICKING: '23A',
    THEFT_PURSE_SNATCHING: '23B',
    THEFT_SHOPLIFTING: '23C',
    THEFT_FROM_BUILDING: '23D',
    THEFT_FROM_THEFT_COINOPERATED_DEVICE: '23E',
    THEFT_MOTOR_VEHICLE: '23F',
    THEFT_MOTOR_VEHICLE_PARTS: '23G',
    THEFT_OTHER: '23H',
    MOTOR_VEHICLE_THEFT: '240',
    PORNOGRAPHY: '370',
    PROSTITUTION: '40',
    PROSTITUTION_BASE: '40A',
    PROSTITUTION_ASSISTANCE: '40B',
    PROSTITUTION_PURCHASING: '40C',
    ROBBERY: '120',
    SEX_OFFENSE: '11',
    SEX_OFFENSE_RAPE: '11A',
    SEX_OFFENSE_SODOMY: '11B',
    SEX_OFFENSE_ASSAULT_WITH_OBJECT: '11C',
    SEX_OFFENSE_FONDLING: '11D',
    SEX_OFFENSE_NONFORCIBLE: '36',
    SEX_OFFENSE_NONFORCIBLE_INCEST: '36A',
    SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE: '36B',
    STOLEN_PROPERTY: '280',
    WEAPON_LAW_VIOLATIONS: '520',
    BAD_CHECKS: '90A',
    CURFEW: '90B',
    DISORDERLY_CONDUCT: '90C',
    DRIVING_UNDER_INFLUENCE: '90D',
    DRUNKENNESS: '90E',
    FAMILY_OFFENSES_NON_VIOLENT: '90F',
    LIQUOR_LAW_VIOLATIONS: '90G',
    PEEPING_TOM: '90H',
    RUNAWAY: '90I',
    TRESSPASSING: '90J',
    OTHER: '90Z'
  })
  .service('CrimeCodeMapper', [
    'CRIME_CODES',
    (CRIME_CODES) ->
      return {
        createFBIMapping: (crimes) ->
          fbiCodes = []

          crimes.forEach (item, index, array) ->
            switch item
              when 'ASSAULT'
                fbiCodes.push(
                  CRIME_CODES.ASSAULT_AGGRAVATED,
                  CRIME_CODES.ASSAULT_SIMPLE,
                  CRIME_CODES.ASSAULT_INTIMIDATION
                )
              when 'DRUG'
                fbiCodes.push(
                  CRIME_CODES.DRUG_NARCOTIC
                )
              when 'FRAUD'
                fbiCodes.push(
                  CRIME_CODES.FRAUD_SWINDLE,
                  CRIME_CODES.FRAUD_CREDIT_CARD,
                  CRIME_CODES.FRAUD_IMPERSONATION,
                  CRIME_CODES.FRAUD_WELFARE,
                  CRIME_CODES.FRAUD_WIRE
                )
              when 'GAMBLING'
                fbiCodes.push(
                  CRIME_CODES.GAMBLING_BETTING,
                  CRIME_CODES.GAMBLING_OPERATING,
                  CRIME_CODES.GAMBLING_EQUIPMENT_VIOLATIONS,
                  CRIME_CODES.GAMBLING_TAMPERING
                )
              when 'HOMICIDE'
                fbiCodes.push(
                  CRIME_CODES.HOMICIDE_NONNEGLIGENT_MANSLAUGHTER,
                  CRIME_CODES.HOMICIDE_NEGLIGENT_MANSLAUGHETER
                )
              when 'HUMAN_TRAFFICKING'
                fbiCodes.push(
                  CRIME_CODES.HUMAN_TRAFFICKING_SEX_ACTS,
                  CRIME_CODES.HUMAN_TRAFFICKING_INVOLUNTARY_SERVITUDE
                )
              when 'THEFT'
                fbiCodes.push(
                  CRIME_CODES.THEFT_POCKET_PICKING,
                  CRIME_CODES.THEFT_PURSE_SNATCHING,
                  CRIME_CODES.THEFT_SHOPLIFTING,
                  CRIME_CODES.THEFT_FROM_BUILDING,
                  CRIME_CODES.THEFT_FROM_THEFT_COINOPERATED_DEVICE,
                  CRIME_CODES.THEFT_MOTOR_VEHICLE,
                  CRIME_CODES.THEFT_MOTOR_VEHICLE_PARTS,
                  CRIME_CODES.THEFT_OTHER,
                  CRIME_CODES.MOTOR_VEHICLE_THEFT
                )
              when 'PROSTITUTION'
                fbiCodes.push(
                  CRIME_CODES.PROSTITUTION_BASE,
                  CRIME_CODES.PROSTITUTION_ASSISTANCE,
                  CRIME_CODES.PROSTITUTION_PURCHASING
                )
              when 'SEX_OFFENSE'
                fbiCodes.push(
                  CRIME_CODES.SEX_OFFENSE_RAPE,
                  CRIME_CODES.SEX_OFFENSE_SODOMY,
                  CRIME_CODES.SEX_OFFENSE_ASSAULT_WITH_OBJECT,
                  CRIME_CODES.SEX_OFFENSE_FONDLING,
                  CRIME_CODES.SEX_OFFENSE_NONFORCIBLE,
                  CRIME_CODES.SEX_OFFENSE_NONFORCIBLE_INCEST,
                  CRIME_CODES.SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE
                )
              else
                fbiCodes.push(CRIME_CODES[item])

          return fbiCodes
      }
])
