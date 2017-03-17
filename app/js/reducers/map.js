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
      console.log('City Overview');
      var neighborhoods = state.neighborhoods || [];

      var polygons = neighborhoods.map(function(neighborhood) {
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
        polygons: polygons,
        markers: [],
        neighborhoodPolygon: null,
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
          neighborhoodPolygon: neighborhoodPolygon,
          polygons: [],
          center: calculatePolygonCenter(neighborhoodPolygon.paths),
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
        ... mapData
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
