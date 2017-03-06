import { combineReducers } from 'redux'
import cityOverview from './city_overview'
import selectedNeighborhood from './selected_neighborhood'

const neighborhoodStat = combineReducers({
  cityOverview,
  selectedNeighborhood
})

export default neighborhoodStat
