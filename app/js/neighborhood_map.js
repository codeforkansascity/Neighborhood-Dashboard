import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'

const MyApp = withGoogleMap(props => {
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
              <InfoWindow position={props.polygons[0]['paths'][0]} onCloseClick={() => props.onMarkerClose(polygon)}>
                <div>{props.polygons[0]['objectid']}</div>
            </InfoWindow>
          </Polygon>
          )}
        )}
        {props.selectedElement && (
            <InfoWindow position={props.getInfoWindowPosition(props.selectedElement)} onCloseClick={() => props.onMarkerClose(props.polygons[0])}>
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
    this.state = {polygons: [], selectedMarker: null}
  }

  componentDidMount() {
    var _this = this;

    axios.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON')
      .then(function(response) {
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
            showInfo: true,
            windowContent: <div><p>{neighborhood.properties.nbhname}</p><a className={'btn btn-primary'}>Go to Neighborhood</a></div>
          };
        })



        _this.setState({polygons: polygons});
      })
      .then(function(error) {
      });
  }

  // Toggle to 'true' to show InfoWindow and re-renders component
  handleMarkerClick(targetMarker) {
    this.setState({
      polygons: this.state.polygons.map(marker => {
        if (marker === targetMarker) {
          return {
            ...marker,
            showInfo: true
          };
        }
        return marker;
      }),
      selectedElement: targetMarker
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
        onMarkerClick={this.handleMarkerClick.bind(this)}
        onMarkerClose={this.handleMarkerClose.bind(this)}
        polygons={this.state.polygons}
        selectedElement={this.state.selectedElement}
        getInfoWindowPosition={this.getInfoWindowPosition.bind(this)}
        children={this.props.children} />
       
    );
  }
}

export default NeighborhoodMap;
