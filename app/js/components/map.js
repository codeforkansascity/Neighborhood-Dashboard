import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'

const MyApp = withGoogleMap(props => {
  console.log('Mapping Center in MyApp');
  console.log(props.center)

  return(
    <div>
      <GoogleMap
        defaultZoom={props.zoom}
        center={props.center}
        defaultCenter={{lat: 39.0997, lng: -94.5786}}>
        {props.markers.map((marker, index) => (
          <Marker {...marker} 
           onClick={() => props.updateSelectedElement(marker)}/>
        ))}
        {props.polygons.map((polygon, index) => {
          var onMouseClick = () => {},
              onMouseOver = () => {};

          if(polygon.selectablePolygon) {
            if(polygon.forceClick || 'ontouchstart' in document.documentElement) {
              onMouseClick = () => props.updateSelectedElement(polygon)
            }
            else {
              onMouseOver = () => props.updateSelectedElement(polygon)
            }
          }

          return(
            <Polygon
              {...polygon}
              key={'neighborhood-' + polygon['objectid']}
              onClick={onMouseClick}
              onMouseOver={onMouseOver}>
            </Polygon>
          )}
        )}
        {props.selectedElement && props.selectedElement.windowContent && (
            <InfoWindow position={props.getInfoWindowPosition(props.selectedElement)} onCloseClick={() => props.updateSelectedElement(null)}>
              <div>{props.selectedElement.windowContent}</div>
            </InfoWindow>
          )
        }
      </GoogleMap>
      <div className="neighborhood-content">
        {props.children}
      </div>
    </div>
    );
  }
);

MyApp.defaultProps = {
  markers: [],
  legend: null,
  polygons: [],
  center: {lat: 39.0997, lng: -94.5786},
  zoom: 14,
  selectedElement: null
};

class Map extends React.Component {
  constructor(props) {
    super(props)
  }

  getInfoWindowPosition(element) {
    switch(element.type) {
      case 'marker':
        return element.position;
      case 'polygon':
        var latitude = 0,
            longtitude = 0,
            coordinatesSize = 0;

        element.paths.forEach ((coord) => {
          coordinatesSize += 1
          latitude += coord.lat;
          longtitude += coord.lng;
        })

        return {lat: latitude / coordinatesSize, lng: longtitude / coordinatesSize}
      default:
        return {lat: 0, lng: 0}
    }
  }

  componentDidMount() {
    var _this = this;

    axios.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON')
      .then(function(response) {
        _this.props.loadNeighborhoods(response.data);
      })
      .then(function(error) {
        console.log(error);
      });
  }

  render() {
    return(
        <MyApp 
          containerElement= { <div style={{height: '100%', width: '100%'}} /> }
          mapElement={ <div style={{height: '100%', width: '100%'}} /> }
          onMapLoad={function() {} }
          onMapClick={function() {} }
          onMarkerRightClick={function() {}}
          polygons={this.props.polygons || []}
          selectedElement={this.props.selectedElement}
          getInfoWindowPosition={this.getInfoWindowPosition.bind(this)}
          updateSelectedElement={this.props.updateSelectedElement}
          center={this.props.center}
          children={this.props.children} />
    );
  }
}

export default Map;
