import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'
import { uploadMapContext } from '../actions'

import LegendContainer from '../containers/legend_container'

const MyApp = withGoogleMap(props => {
  return(
    <div>
      <GoogleMap
        ref={props.onMapLoad}
        defaultZoom={props.zoom}
        center={props.center}
        defaultCenter={{lat: 39.0997, lng: -94.5786}}>
        <LegendContainer />
        {props.markers.map((marker, index) => (
          <Marker {...marker} 
           onClick={(e) => {props.updateSelectedElement(marker)}}/>
        ))}
        {
          props.neighborhoodPolygon && 
          <Polygon {...props.neighborhoodPolygon} />
        }
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
      {props.children}
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

    this.handleMapMounted = this.handleMapMounted.bind(this);
  }

  handleMapMounted(map) {
    this.props.addMap(map.context.__SECRET_MAP_DO_NOT_USE_OR_YOU_WILL_BE_FIRED)
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
          onMapLoad={this.handleMapMounted}
          onMapClick={function() {} }
          onMarkerRightClick={function() {}}
          markers={this.props.markers || []}
          polygons={this.props.polygons || []}
          selectedElement={this.props.selectedElement}
          getInfoWindowPosition={this.getInfoWindowPosition.bind(this)}
          updateSelectedElement={this.props.updateSelectedElement}
          neighborhoodPolygon={this.props.neighborhoodPolygon}
          center={this.props.center}
          children={this.props.children} />
    );
  }
}

export default Map;
