import React from 'react';
import { render } from 'react-dom';
import { Router, Route, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

import NeighborhoodMapContainer from './containers/neighborhood_map_container';
import Crime from './crime';
import reducer from './reducers';

const store = createStore(reducer)

render(
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route path="/" component={NeighborhoodMapContainer}>
        <Route path="neighborhood/:neighborhoodId/crime" component={Crime}/>
      </Route>
    </Router>
  </Provider>,
  document.getElementById('root')
);
