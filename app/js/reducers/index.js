import { combineReducers } from 'redux'
import map from './map'
import Legend from './legend'

const neighborhoodStat = combineReducers({
  map,
  Legend
});

export default neighborhoodStat;
