const selectedNeighborhood = (state = {}, action) => {
  switch (action.type) {
    case 'SWITCH_NEIGHBORHOOD':
      return {
        ...state,
        swapNeighborhood: true,
        neighborhood: action.neighborhood,
        datasets: [],
        neighborhoods: [],
        polygons: [],
      }
    default:
      return state
  }
}

export default selectedNeighborhood;
