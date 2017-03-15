import { combineReducers } from 'redux'
import cityOverview from './city_overview'
import selectedNeighborhood from './selected_neighborhood'
import map from './map'
import Legend from './legend'

const neighborhoodStat = combineReducers({
  cityOverview,
  selectedNeighborhood,
  map,
  Legend
});

export default neighborhoodStat;
