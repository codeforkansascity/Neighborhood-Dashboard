export const updateMap = (mapData) => {
  return({
    type: 'UPDATE_MAP',
    mapData
  })
}

export const addMap = (map) => {
  return({
    type: 'ADD_MAP',
    map
  })
}
export const fetchNeighborhoods = (data) => {
  return({
    type: 'FETCH_NEIGHBORHOODS',
    data
  })
}

export const updateSelectedElement = (element) => {
  return({
    type: 'UPDATE_SELECTED_ELEMENT',
    element
  })
}

export const cityOverview = (response) => {
  return ({
    type: 'CITY_OVERVIEW',
    response
  })
}

export const neighborhoodReset = (neighborhoodId) => {
  return({
    type: 'NEIGHBORHOOD_RESET',
    neighborhoodId
  })
}

export const updateLegend = (legend) => {
  return({
    type: 'UPDATE_LEGEND',
    legend
  })
}
