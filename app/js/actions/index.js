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
    type: 'HOMEPAGE_OVERVIEW',
    response
  })
}

export const neighborhoodReset = (neighborhoodId) => {
  return({
    type: 'NEIGHBORHOOD_RESET',
    neighborhoodId: neighborhoodId
  })
}
