import React from 'react'
import { render } from 'react-dom'
import PrimaryNavigation from './primary_navigation'
import MapContainer from '../containers/map_container'

class Application extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return(
      <div className="application-wrapper">
        <PrimaryNavigation />
        <MapContainer>
          {this.props.children}
        </MapContainer>
      </div>
    );
  }
}

export default Application;
