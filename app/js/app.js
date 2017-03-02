import React from 'react';
import { render } from 'react-dom';
import { Router, Route, browserHistory } from 'react-router';

import NeighborhoodMap from './neighborhood_map';
import Crime from './crime';

render(
  <Router history={browserHistory}>
    <Route path="/" component={NeighborhoodMap}>
      <Route path="neighborhood/:neighborhoodId/crime" component={Crime}/>
    </Route>
  </Router>,
  document.getElementById('root')
);
