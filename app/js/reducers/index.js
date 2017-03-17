import { combineReducers } from 'redux'
import selectedNeighborhood from './selected_neighborhood'
import map from './map'
import Legend from './legend'

const neighborhoodStat = combineReducers({
  selectedNeighborhood,
  map,
  Legend
});

export default neighborhoodStat;
