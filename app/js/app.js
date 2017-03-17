import React from 'react';
import { render } from 'react-dom';
import { Router, Route, IndexRoute, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

import Application from './components/application';
import Vacancy from './components/vacancy';
import NeighborhoodContainer from './containers/neighborhood_container';
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
        <Route path="/neighborhood/:neighborhoodId/" component={NeighborhoodContainer}>
          <Route path="crime" component={CrimeContainer}/>
          <Route path="vacancy" component={Vacancy}/>
        </Route>
      </Route>
    </Router>
  </Provider>,
  document.getElementById('root')
);
