import React from 'react';
import { render } from 'react-dom';
import PrimaryNavigation from './primary_navigation';
import MapContainer from '../containers/map_container';

import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.min.css';
import '../style_overrides/react-toastify.css';

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
        <ToastContainer autoClose={50000} position="top-center" />
      </div>
    );
  }
}

export default Application;
