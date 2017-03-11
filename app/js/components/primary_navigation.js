import React from 'react'
import { render } from 'react-dom'

class PrimaryNavigation extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return(
      <nav className="navbar navbar-default navbar-fixed-top">
        <div className="navbar-header">
          <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#primary-nav" aria-expanded="false" aria-controls="navbar">
              <span className="sr-only">Toggle navigation</span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
          </button>
          <a href="/" className="navbar-brand"><span className="logo-prefix">KC</span>NeighborhoodStat</a>
        </div>
        <nav id="primary-nav" className="collapse navbar-collapse">
          <ul className="nav navbar-nav navbar-right">
            <li><a href="#">About</a></li>
            <li><a href="#">Our Data</a></li>
            <li><a href="#">Contact</a></li>
            <li><a href="#" data-toggle="modal" data-target="#neighborhood-search-modal">Neighborhood Search</a></li>
          </ul>
        </nav>
      </nav>
    );
  }
}

export default PrimaryNavigation;
