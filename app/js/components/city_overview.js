import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'

class CityOverview extends React.Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    var _this = this;

    axios.get('https://data.kcmo.org/api/geospatial/q45j-ejyk?method=export&format=GeoJSON')
      .then(function(response) {
        _this.props.loadOverview(response);
      })
      .then(function(error) {
        console.log(error);
      });
  }

  render() {
    return(
      <div></div>
    );
  }
}

export default CityOverview;
