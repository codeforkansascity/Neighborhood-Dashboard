import React from 'react';
import { render } from 'react-dom';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.min.css';
import PrimaryNavigation from './primary_navigation';
import MapContainer from '../containers/map_container';

import '../style_overrides/react-toastify.css';

const Application = function (props) {
  return (
    <div className="application-wrapper">
      <PrimaryNavigation />
      <MapContainer>
        {props.children}
      </MapContainer>
      <ToastContainer autoClose={50000} position="top-center" />
    </div>
  );
};


export default Application;
