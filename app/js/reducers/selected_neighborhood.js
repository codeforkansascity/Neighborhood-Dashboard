const selectedNeighborhood = (state = {}, action) => {
  switch (action.type) {
    case 'SWITCH_NEIGHBORHOOD':
      return {
        ...state,
        neighborhood: action.neighborhood,
        datasets: []
      }
    default:
      return state
  }
}

export default selectedNeighborhood;
