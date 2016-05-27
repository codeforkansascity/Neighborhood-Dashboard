angular
  .module('neighborhoodstat')
  .service('StackedMarkerMapper', [
    () ->
      createStackedMarkerDataSet: (dataSet) ->
        currentData = []

        dataSet.forEach (dataPoint) ->
          if dataPoint.properties.disclosure_attributes.length > 1
            dataPoint.properties.disclosure_attributes.forEach (disclosureAttribute, i) ->
              newDataPoint = {}
              angular.copy(dataPoint, newDataPoint)
              newDataPoint.geometry.coordinates[1] -= 0.0002 * i
              newDataPoint.properties.disclosure_attributes = [disclosureAttribute]

              # We want to make sure that all stacked markers have the same color so that the user knows it all belongs to the same address
              newDataPoint.properties.color = "#555555"
              currentData.push(newDataPoint)
          else
            currentData.push(dataPoint)

        return currentData
  ])
