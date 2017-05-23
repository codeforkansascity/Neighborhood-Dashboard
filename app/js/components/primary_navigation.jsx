import React from 'react'
import { render } from 'react-dom'
import { browserHistory, Link } from 'react-router';
import Modal from 'react-modal';
import axios from 'axios';

import NeighborhoodSearch from './neighborhood_search';

class PrimaryNavigation extends React.Component {
  constructor(props) {
    super(props)
    this.state = {modalIsOpen: false};

    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.neighborhoodSearchChange = this.neighborhoodSearchChange.bind(this);
    this.searchNeighborhood = this.searchNeighborhood.bind(this);
    this.dismissSearchFailureMessage = this.dismissSearchFailureMessage.bind(this);
  }

  componentWillReceiveProps() {
    this.setState({modalIsOpen: false});
  }

  openModal(e) {
    e.preventDefault();
    this.setState({modalIsOpen: true});
  }

  closeModal(e) {
    e.preventDefault();
    this.setState({modalIsOpen: false});
  }

  homeRedirect(e) {
    e.preventDefault();
    browserHistory.push('/')
  }

  searchNeighborhood(e) {
    e.preventDefault();
    var _this = this;

    this.setState({
      ... this.state,
      searching: true,
      searchFailure: false
    });

    axios.get('/api/neighborhood/locate?search_address=' + this.state.neighborhoodSearch)
      .then(function(response) {
        browserHistory.replace('/neighborhood/' + response.data.id + '/crime');
      })
      .catch(function(error) {
        console.log(error);

        _this.setState({
          ... _this.state,
          searching: false,
          searchFailure: true
        })
      });
  }

  neighborhoodSearchChange(e) {
    this.setState({
      ... this.state,
      neighborhoodSearch: e.target.value
    })
  }

  dismissSearchFailureMessage() {
    this.setState({
      ... this.state,
      searchFailure: false
    })
  }

  render() {
    return(
      <div>
        <Modal
          contentLabel="neighborhood-search"
          isOpen={this.state.modalIsOpen}
          style={
            {
              overlay: {
                position: 'absolute', 
                left: '0px', 
                top: '0px', 
                width: '100%', 
                height: '100%', 
                zIndex: 2
              },
              content: {
                padding: 0,
                bottom: 'auto'
              }
            }
          }
        >
          <form className="neighborhood-search form-inline" role="search" onSubmit={this.searchNeighborhood}>
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true" onClick={this.closeModal}>×</span>
              </button>
              <h4 className="modal-title">Neighborhood Search</h4>
            </div>
            <div className="modal-body">
              {this.state.searchFailure && <p className="alert alert-danger fade in">
                <span className="close" aria-label="close" title="close" onClick={this.dismissSearchFailureMessage}>×</span>
                Neighborhood Not Found
              </p>}
              <p className="form-group">
                <label for="neighborhood-search">Find Neighborhood</label>
                <NeighborhoodSearch />
              </p>
              <p className="form-group">
                <label for="neighborhood-address">Or</label>
                <input type="text" id="neighborhood-address" onChange={this.neighborhoodSearchChange} name="search_address" className="form-control" placeholder="Enter Address"/>
              </p>
            </div>
            <div className="modal-footer">
              {!this.state.searching && <input type="submit" className="form-control btn btn-success" value="Search"/>}
              {this.state.searching && <span className="glyphicon glyphicon-refresh spin"></span>}
            </div>
          </form>
        </Modal>
        <nav className="navbar navbar-default">
          <div className="navbar-header">
            <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#primary-nav" aria-expanded="false" aria-controls="navbar">
                <span className="sr-only">Toggle navigation</span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
            </button>
            <a href="/" onClick={this.homeRedirect} className="navbar-brand"><span className="logo-prefix">KC</span>NeighborhoodStat</a>
          </div>
          <nav id="primary-nav" className="collapse navbar-collapse">
            <ul className="nav navbar-nav navbar-right">
              <li><Link to="/about">About</Link></li>
              <li><a href="#" onClick={this.openModal} data-toggle="modal" data-target="#neighborhood-search-modal">Neighborhood Search</a></li>
            </ul>
          </nav>
        </nav>
      </div>
    );
  }
}

export default PrimaryNavigation;
