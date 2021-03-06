import React from 'react';
import { render } from 'react-dom';
import axios from 'axios';
import { toast } from 'react-toastify';

import CodeForKcLogo from '../images/code_for_kc.png';
import GoogleMapsElement from './google_maps_element';

class Map extends React.Component {
  constructor(props) {
    super(props);

    this.handleMapMounted = this.handleMapMounted.bind(this);
  }

  componentDidMount() {
    var _this = this;

    axios.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON')
      .then(function(response) {
        _this.props.loadNeighborhoods(response.data);
      })
      .catch(function(error) {
        toast(
          <p>Main Neighborhood map could not load. Please try again later,
            or try the neighborhood search.</p>, {
              type: toast.TYPE.INFO,
            });
      });
  }

  getInfoWindowPosition(element) {
    switch (element.type) {
      case 'marker':
        return element.position;
      case 'polygon':
        let latitude = 0;
        let longtitude = 0;
        let coordinatesSize = 0;

        element.paths.forEach((coord) => {
          coordinatesSize += 1;
          latitude += coord.lat;
          longtitude += coord.lng;
        });

        console.log('Calculating polygon center');
        return { lat: latitude / coordinatesSize, lng: longtitude / coordinatesSize };
      default:
        return { lat: 0, lng: 0 };
    }
  }

  handleMapMounted(map) {
    if (map) {
      this.props.addMap(map.context.__SECRET_MAP_DO_NOT_USE_OR_YOU_WILL_BE_FIRED);
    } else {
      this.props.addMap(null);
    }
  }

  render() {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
        {this.props.children}
        <GoogleMapsElement
          containerElement={<div style={{flexGrow: '1', display: 'flex', minHeight: '400px' }} />}
          mapElement={<div style={{ flexGrow: '1' }} />}
          onMapLoad={this.handleMapMounted}
          onMapClick={function () {}}
          onMarkerRightClick={function () {}}
          markers={this.props.markers || []}
          polygons={this.props.polygons || []}
          neighborhoods={this.props.neighborhoods || []}
          selectedMapElement={this.props.selectedMapElement}
          getInfoWindowPosition={this.getInfoWindowPosition.bind(this)}
          updateSelectedMapElement={this.props.updateSelectedMapElement}
          selectedNeighborhood={this.props.selectedNeighborhood}
          center={this.props.center}
        />
        <footer className="application-footer">
          This project developed by CodeForKC - A Code for America Organization&nbsp;&nbsp;&nbsp;
            <a href="http://codeforkc.org/">
              <img src={CodeForKcLogo} alt="Code for KC Logo" />
            </a>
        </footer>
      </div>
    );
  }
}

export default Map;
