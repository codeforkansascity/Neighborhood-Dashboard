import React from 'react';
import { render } from 'react-dom';

const cityOverview = (state = {}, action) => {
  console.log(action.type)
  console.log(action.neighborhood)
  switch (action.type) {
    case 'NEIGHBORHOOD_HOVER':
      return {
        ...state,
        selectedElement: action.neighborhood
      }
    case 'NEIGHBORHOOD_LINK_CLOSE':
      return {
        ...state,
        selectedElement: null
      }
    case 'HOMEPAGE_OVERVIEW':
      var response = action.response;
      var validNeighborhoods = response["data"]["features"].filter((neighborhood) => {
        return neighborhood['properties']['nbhname'];
      });

      var polygons = validNeighborhoods.map(function(neighborhood) {
        var paths = neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
          return {lng: coordinates[0], lat: coordinates[1]}
        });

        return {
          type: 'polygon',
          paths: paths,
          objectid: neighborhood['properties']['objectid'], 
          windowContent: <div><p>{neighborhood.properties.nbhname}</p><a className={'btn btn-primary'}>Go to Neighborhood</a></div>
        };
      });

      return {
        ...state,
        neighborhoods: validNeighborhoods,
        polygons: polygons
      }
    default:
      return state
  }
}

export default cityOverview;
