import { combineReducers } from 'redux'
import cityOverview from './city_overview'
import selectedNeighborhood from './selected_neighborhood'
import map from './map'

const neighborhoodStat = combineReducers({
  cityOverview,
  selectedNeighborhood,
  map
});

export default neighborhoodStat;
