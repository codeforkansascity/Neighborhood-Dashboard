import React from 'react';
import LegendContainer from '../containers/legend_container'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps';

const GoogleMapsElement = withGoogleMap(props => {
  return(
    <GoogleMap
      ref={props.onMapLoad}
      defaultZoom={props.zoom}
      center={props.center}
      gestureHandling={'cooperative'}
      defaultCenter={{lat: 39.0997, lng: -94.5786}}>
      <LegendContainer />
      {
        props.neighborhoodPolygon && 
        <Polygon {...props.neighborhoodPolygon} />
      }
      {props.markers.map((marker, index) => (
        <Marker {...marker}
         onClick={(e) => {props.updateSelectedElement(marker)}}/>
      ))}
      {props.polygons.map((polygon, index) => {
        var onMouseClick = () => {};

        if(!(props.neighborhoodPolygon && props.neighborhoodPolygon.objectid === polygon.objectid) && polygon.selectablePolygon) {
          onMouseClick = () => props.updateSelectedElement(polygon);
        }

        return(
          <Polygon
            {...polygon}  
            onClick={onMouseClick}
            key={polygon.objectid} />
        )}
      )}
      {props.selectedElement && props.selectedElement.windowContent && (
          <InfoWindow
            position={props.getInfoWindowPosition(props.selectedElement)}
            onCloseClick={() => props.updateSelectedElement(null)}>
            <div style={props.selectedElement.windowStyle}>{props.selectedElement.windowContent}</div>
          </InfoWindow>
        )
      }
    </GoogleMap>
    );
  }
);

GoogleMapsElement.defaultProps = {
  markers: [],
  legend: null,
  polygons: [],
  center: {lat: 39.0997, lng: -94.5786},
  zoom: 14,
  selectedElement: null
};

export default GoogleMapsElement;
