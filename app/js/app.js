import React from 'react';
import { render } from 'react-dom';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

import Application from './components/application';
import MapContainer from './containers/map_container';
import CrimeContainer from './containers/crime_container';
import CityOverviewContainer from './containers/city_overview_container';
import reducer from './reducers';

const store = createStore(reducer)

render(
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route path="/" component={Application}>
        <IndexRoute component={CityOverviewContainer}/>
        <Route path="neighborhood/:neighborhoodId/crime" component={CrimeContainer}/>
      </Route>
    </Router>
  </Provider>,
  document.getElementById('root')
);
