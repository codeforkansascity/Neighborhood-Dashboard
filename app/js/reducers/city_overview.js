import React from 'react';
import { render } from 'react-dom';
import { browserHistory } from 'react-router';

const pushState = (state) => {
  browserHistory.push(state);
}

const cityOverview = (state = {}, action) => {
  switch (action.type) {
    case 'NEIGHBORHOOD_OVERVIEW':
      var neighborhood = state.polygons.find(function(hood) {
        return hood.objectid == action.neighborhoodId
      });

      var polygon = {
        type: 'polygon',
        paths: neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
          return {lng: coordinates[0], lat: coordinates[1]}
        }),
        objectid: neighborhood.properties.objectid
      }

      return {
        ...state,
        neighborhood: neighborhood,
        polygons: [polygon],
        selectedElement: null
      }
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

      if (!response) {
        return {
          ...state
        }
      }

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
          windowContent: 
            <div>
              <p>{neighborhood.properties.nbhname}</p>
              <a className={'btn btn-primary'} onClick={() => {pushState('/neighborhood/' + neighborhood.properties.objectid + '/crime')}}>Go to Neighborhood</a>
            </div>
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
