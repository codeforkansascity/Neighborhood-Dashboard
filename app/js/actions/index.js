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

export const getNeighborhood = (neighborhood) => {
  return({
    type: 'GET_NEIGHBORHOOD',
    neighborhoodId
  })
}
export const switchNeighborhood = (neighborhood) => {
  return ({
    type: 'SWITCH_NEIGHBORHOOD',
    neighborhood
  })
}

export const neighborhoodHover = (neighborhood) => {
  return({
    type: 'NEIGHBORHOOD_HOVER',
    neighborhood
  })
}

export const closeNeighborhoodLink = () => {
  return({
    type: 'NEIGHBORHOOD_LINK_CLOSE'
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
