import React from 'react';
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps';

import LegendContainer from '../containers/legend_container';


const GoogleMapsElement = withGoogleMap(props => {
  return (
    <GoogleMap
      ref={props.onMapLoad}
      defaultZoom={props.zoom}
      center={props.center}
      gestureHandling={'cooperative'}
      defaultCenter={{ lat: 39.0997, lng: -94.5786 }}
    >
      <LegendContainer />
      {
        props.selectedNeighborhood &&
        <Polygon
          {...props.selectedNeighborhood}
          options={{ fillColor: '#111111' }}
        />
      }
      {props.neighborhoods.map((polygon, index) => {
        if (props.selectedNeighborhood &&
          props.selectedNeighborhood.objectid === polygon.objectid) {
          return null;
        }

        let onMouseClick = () => props.updateSelectedMapElement(polygon);

        return (
          <Polygon
            {...polygon}
            onClick={onMouseClick}
            key={polygon.objectid}
          />
        );
      },
      )}
      {props.markers.map((marker, index) => (
        <Marker
          {...marker}
          onClick={(e) => { props.updateSelectedMapElement(marker); }}
        />
      ))}
      {
        props.polygons.map((polygon, index) => {
          var onMouseClick = () => props.updateSelectedMapElement(polygon);

          return (
            <Polygon
              {...polygon}
              options={{ zIndex: 200 }}
              onClick={onMouseClick}
              key={polygon.objectid}
            />
          );
        },
      )}
      {
        props.selectedMapElement && props.selectedMapElement.windowContent && (
          <InfoWindow
            position={props.getInfoWindowPosition(props.selectedMapElement)}
            onCloseClick={() => props.updateSelectedMapElement(null)}
          >
            <div style={props.selectedMapElement.windowStyle}>
              {props.selectedMapElement.windowContent}
            </div>
          </InfoWindow>
        )
      }
    </GoogleMap>
  );
},
);

GoogleMapsElement.defaultProps = {
  markers: [],
  legend: null,
  polygons: [],
  center: { lat: 39.0997, lng: -94.5786 },
  zoom: 14,
  selectedElement: null,
};

export default GoogleMapsElement;
