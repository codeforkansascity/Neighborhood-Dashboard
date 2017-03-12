import React from 'react';
import { render } from 'react-dom';
import { browserHistory } from 'react-router';

const pushState = (state) => {
  browserHistory.push(state);
} 

const map = (state = {}, action) => {
  switch(action.type) {
    case 'CITY_OVERVIEW':
      var neighborhoods = state.neighborhoods || [];

      var polygons = neighborhoods.map(function(neighborhood) {
        return {
          type: 'polygon',
          paths: neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
            return {lng: coordinates[0], lat: coordinates[1]}
          }),
          objectid: neighborhood.properties.objectid,
          windowContent: 
            <div>
              <p>{neighborhood.properties.nbhname}</p>
              <a className={'btn btn-primary'} onClick={() => {pushState('/neighborhood/' + neighborhood.properties.objectid + '/crime')}}>Go to Neighborhood</a>
            </div>
        }
      });

      return {
        ...state,
        polygons: polygons,
        selectedElement: null
      }
    case 'FETCH_NEIGHBORHOODS':
      var data = action.data;
      var validNeighborhoods = data["features"].filter((neighborhood) => {
        return neighborhood['properties']['nbhname'];
      });

      return {
        ...state,
        neighborhoods: validNeighborhoods
      }
    case 'NEIGHBORHOOD_RESET':
      var neighborhoods = state.neighborhoods || [];

      var neighborhood = neighborhoods.find(function(hood) {
        return hood.properties.objectid == action.neighborhoodId
      });

      if (neighborhood) {
        var neighborhoodPolygon = {
          type: 'polygon',
          paths: neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
            return {lng: coordinates[0], lat: coordinates[1]}
          }),
          objectid: neighborhood.properties.objectid
        };

        return {
          ...state,
          neighborhood: neighborhood,
          polygons: [neighborhoodPolygon],
          selectedElement: null
        }
      }
      else {
        return {
          ...state,
          neighborhood: null,
          polygons: [],
          selectedElement: null
        }
      }
    case 'UPDATE_MAP':
      var mapData = action.mapData;

      return {
        ... state,
        markers: mapData.markers,
        legend: mapData.legend,
        polygons: mapData.polygons,
        center: mapData.center,
        selectedElement: mapData.selectedElement
      };
    case 'UPDATE_SELECTED_ELEMENT':
      return {
        ... state,
        selectedElement: action.element
      }
    default:
      return state;
  }
}

export default map;