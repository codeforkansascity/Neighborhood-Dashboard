import React from 'react'
import { render } from 'react-dom'
import { browserHistory } from 'react-router';
import Modal from 'react-modal';

class PrimaryNavigation extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      modalIsOpen: false
    };

    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
  }

  openModal(e) {
    e.preventDefault();
    this.setState({
      modalIsOpen: true
    });
  }

  closeModal(e) {
    e.preventDefault();
    this.setState({
      modalIsOpen: false
    });
  }

  homeRedirect(e) {
    e.preventDefault();
    browserHistory.push('/')
  }

  render() {
    return(
      <div>
        <Modal
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
          <form className="neighborhood-search form-inline" role="search">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true" onClick={this.closeModal}>×</span>
              </button>
              <h4 className="modal-title">Neighborhood Search</h4>
            </div>
            <div className="modal-body">
              <p className="form-group">
                <label for="neighborhood-search">Find Neighborhood</label>
                <select id="neighborhood-search" name="search_neighborhood" className="form-control" placeholder="Enter neighborhood name"></select>
              </p>
              <p className="form-group">
                <label for="neighborhood-address">Or</label>
                <input type="text" id="neighborhood-address" name="search_address" className="form-control" placeholder="Enter Address"/>
              </p>
            </div>
            <div className="modal-footer">
              <input type="submit" className="form-control btn btn-success" value="Search"/>
              <span className="glyphicon glyphicon-refresh spin"></span>
            </div>
          </form>
        </Modal>
        <nav className="navbar navbar-default navbar-fixed-top">
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
              <li><a href="#">About</a></li>
              <li><a href="#">Our Data</a></li>
              <li><a href="#">Contact</a></li>
              <li><a href="#" onClick={this.openModal} data-toggle="modal" data-target="#neighborhood-search-modal">Neighborhood Search</a></li>
            </ul>
          </nav>
        </nav>
      </div>
    );
  }
}

export default PrimaryNavigation;
