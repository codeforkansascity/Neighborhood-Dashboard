import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'

const MyApp = withGoogleMap(props => {
  console.log('Props');
  console.log(props);

  return(
    <div>
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
        {props.polygons.map((polygon, index) => {
          var onMouseClick, onMouseOver;

          if('ontouchstart' in document.documentElement) {
            onMouseClick = () => props.onMarkerClick(polygon)
            onMouseOver = null
          }
          else {
            onMouseOver = () => props.onMarkerClick(polygon)
            onMouseClick = null
          }

          return(
            <Polygon
              {...polygon}
              key={'neighborhood-' + polygon['objectid']}
              onMouseClick={onMouseClick}
              onMouseOver={onMouseOver}>
            </Polygon>
          )}
        )}
        {props.selectedElement && (
            <InfoWindow position={props.getInfoWindowPosition(props.selectedElement)} onCloseClick={() => props.onMarkerClose()}>
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
  name: 'asd',
  markers: [],
  polygons: [],
  onMapLoad: function() {}
};

class NeighborhoodMap extends React.Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    var _this = this;

    axios.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON')
      .then(function(response) {
        _this.props.loadOverview(response)
      })
      .then(function(error) {
      });
  }

  handleMarkerClose(targetMarker) {
    this.setState({
      polygons: this.state.polygons.map(marker => {
        if (marker === targetMarker) {
          return {
            ...marker,
            showInfo: false,
          };
        }
        return marker;
      }),
      selectedElement: null
    });
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

  render() {
    return(
        <MyApp 
        containerElement= { <div style={{height: '100%', width: '100%'}} /> }
        mapElement={ <div style={{height: '100%', width: '100%'}} /> }
        onMapLoad={function() {} }
        onMapClick={function() {} }
        onMarkerRightClick={function() {}}
        onMarkerClick={this.props.currentNeighborhoodChoice.bind(this)}
        onMarkerClose={this.props.closeNeighborhoodLink.bind(this)}
        polygons={this.props.polygons || []}
        selectedElement={this.props.selectedElement}
        getInfoWindowPosition={this.getInfoWindowPosition.bind(this)}
        children={this.props.children} />
       
    );
  }
}

export default NeighborhoodMap;
