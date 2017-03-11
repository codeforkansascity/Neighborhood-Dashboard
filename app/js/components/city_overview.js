import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'

class CityOverview extends React.Component {
  constructor(props) {
    super(props)
  }

  componentWillUpdate(nextProps, State) {
    this.props.loadOverview();
  }

  render() {
    return(
      <div></div>
    );
  }
}

export default CityOverview;
