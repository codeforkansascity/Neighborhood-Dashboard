import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap } from 'react-google-maps'

const MyApp = withGoogleMap(props => (
  <GoogleMap
    ref={props.onMapLoad}
    defaultZoom={14 }
    defaultCenter={{ lat: 39.0997, lng: -94.5786 }}
    onClick={props.onMapClick}>
    {props.markers.map((marker, index) => (
      <Marker
        {...marker}
        onRightClick={() => props.onMarkerRightClick(index)}
      />
    ))}
  </GoogleMap>
));

MyApp.defaultProps = {
  name: 'asd',
  markers: [],
  onMapLoad: function() {}
};

class NeighborhoodMap extends React.component {
  componentDidMount: function() {
    axios.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON')
      .then(function(response) {
        console.log(response);
      })
      .then(function(error) {
        console.log(error);
      });
  },

  render(
    <MyApp 
      containerElement= { <div style={{height: '100%', width: '100%'}} /> }
      mapElement={ <div style={{height: '100%', width: '100%'}} /> }
      onMapLoad={function() {} }
      onMapClick={function() {} }
      onMarkerRightClick={function() {}}
    />
  )
}

export default NeighborhoodMap;
