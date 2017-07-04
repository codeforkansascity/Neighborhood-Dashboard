import React from 'react';
import { render } from 'react-dom';
import { browserHistory } from 'react-router';

const pushState = (state) => {
  browserHistory.push(state);
}

const calculatePolygonCenter = (paths) => {
  var latitude = 0,
      longtitude = 0,
      coordinatesSize = 0;

  paths.forEach ((coord) => {
    coordinatesSize += 1
    latitude += coord.lat;
    longtitude += coord.lng;
  });

  return {lat: (latitude / coordinatesSize) + 0.006, lng: longtitude / coordinatesSize}
}

const map = (state = {}, action) => {
  switch(action.type) {
    case 'ADD_MAP':
      return {
        ... state,
        map: action.map
      }
    case 'CITY_OVERVIEW':
      var neighborhoods = state.neighborhoods || [];

      if (!state.neighborhoods) {
        var neighborhoodPolygons = neighborhoods.map(function(neighborhood) {
          return {
            type: 'polygon',
            paths: neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
              return {lng: coordinates[0], lat: coordinates[1]}
            }),
            objectid: neighborhood.properties.objectid,
            selectablePolygon: true,
            windowContent: 
              <div>
                <p>{neighborhood.properties.nbhname}</p>
                <a className={'btn btn-primary'} onClick={() => {pushState('/neighborhood/' + neighborhood.properties.objectid + '/crime')}}>Go to Neighborhood</a>
              </div>
          }
        });

        return {
          ...state,
          neighborhoods: neighborhoodPolygons,
          polygons: [],
          markers: [],
          selectedNeighborhood: null,
          selectedMapElement: null
        }
      } else {
        return {
          ...state
        }
      }
    case 'FETCH_NEIGHBORHOODS':
      var data = action.data;
      var validNeighborhoods = data["features"].filter((neighborhood) => {
        return neighborhood['properties']['nbhname'];
      });

      var polygons = validNeighborhoods.map(function(neighborhood) {
        return {
          type: 'polygon',
          paths: neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
            return {lng: coordinates[0], lat: coordinates[1]}
          }),
          objectid: neighborhood.properties.objectid,
          selectablePolygon: true,
          options: {
            fillColor: '#777777'
          },
          windowContent: 
            <div>
              <p>{neighborhood.properties.nbhname}</p>
              <a className={'btn btn-primary'} onClick={() => {pushState('/neighborhood/' + neighborhood.properties.objectid + '/crime')}}>Go to Neighborhood</a>
            </div>
        }
      });

      return {
        ...state,
        neighborhoods: polygons
      }
    case 'NEIGHBORHOOD_RESET':
      var neighborhoods = state.neighborhoods || [];

      var selectedNeighborhood = neighborhoods.find(function(hood) {
        return hood.objectid == action.neighborhoodId
      });

      if (selectedNeighborhood) {
        return {
          ...state,
          selectedNeighborhood: selectedNeighborhood,
          center: calculatePolygonCenter(selectedNeighborhood.paths),
          selectedMapElement: null
        }
      }
      else {
        return {
          ...state,
          selectedNeighborhood: null,
          polygons: [],
          markers: [],
          selectedMapElement: null
        }
      }
    case 'UPDATE_MAP':
      var mapData = Object.assign({}, action.mapData);

      return {
        ... state,
        ... mapData
      };
    case 'UPDATE_SELECTED_MAP_ELEMENT':
      return {
        ... state,
        selectedMapElement: action.element
      }
    default:
      return state;
  }
}

export default map;
