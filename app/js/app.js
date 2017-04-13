import React from 'react';
import { render } from 'react-dom';
import { Router, Route, IndexRoute, IndexRedirect, browserHistory } from 'react-router';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

import Application from './components/application';
import Demographics from './components/demographics';

import NeighborhoodContainer from './containers/neighborhood_container';
import MapContainer from './containers/map_container';
import CrimeContainer from './containers/crime_container';
import VacancyContainer from './containers/vacancy_container';
import CityOverviewContainer from './containers/city_overview_container';
import About from './components/about';

import reducer from './reducers';

const store = createStore(reducer)

render(
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route path="/about" component={About} />
      <Route path="/" component={Application}>
        <IndexRoute component={CityOverviewContainer}/>
        <Route path="/neighborhood/:neighborhoodId/" component={NeighborhoodContainer}>
          <IndexRedirect to="crime"/>
          <Route path="crime" component={CrimeContainer}/>
          <Route path="vacancy" component={VacancyContainer}/>
          <Route path="demographics" component={Demographics}/>
        </Route>
      </Route>
    </Router>
  </Provider>,
  document.getElementById('root')
);
