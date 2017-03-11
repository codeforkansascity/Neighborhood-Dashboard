import React from 'react'
import { render } from 'react-dom'
import { withGoogleMap, GoogleMap, Polygon, InfoWindow, Marker } from 'react-google-maps'
import axios from 'axios'

class CityOverview extends React.Component {
  constructor(props) {
    super(props)
  }

  componentDidMount(nextProps, State) {
    console.log('Did Mount');
    this.props.loadOverview();
  }

  componentWillUpdate(nextProps, State) {
    console.log('Will Update');
    this.props.loadOverview();
  }

  render() {
    return(
      <div></div>
    );
  }
}

export default CityOverview;
