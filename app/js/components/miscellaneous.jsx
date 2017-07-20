import React from 'react';
import { render } from 'react-dom';
import axios from 'axios';
import { toast } from 'react-toastify';

import '../modernizr-bundle';

const formatResponse = (response) => {
  const markers = response.data.map((dataPoint) => {
    return (
    {
      type: 'marker',
      position: {
        lat: dataPoint.geometry.coordinates[1],
        lng: dataPoint.geometry.coordinates[0],
      },
      icon: {
        path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z M -2,-30 a 2,2 0 1,1 4,0 2,2 0 1,1 -4,0',
        fillColor: dataPoint.properties.color,
        fillOpacity: 1,
        strokeColor: '#000',
        strokeWeight: 2,
        scale: 1,
      },
      defaultAnimation: 2,
      windowContent: dataPoint.properties.disclosure_attributes.map(
        (attribute) => <div dangerouslySetInnerHTML={{ __html: attribute }} />,
      ),
    });
  });

  return { markers: markers, polygons: [] };
};

class Miscellaenous extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      filters: [],
      filtersViewable: false,
      viewingReport: false,
    };

    this.handleFilterChange = this.handleFilterChange.bind(this);
    this.toggleFilters = this.toggleFilters.bind(this);
    this.queryDataset = this.queryDataset.bind(this);
  }

  handleFilterChange(event) {
    const currentFilters = this.state.filters;
    const selectedFilters = event.currentTarget.value;
    const filterIsActive = event.currentTarget.checked;

    if (filterIsActive) {
      currentFilters.push(selectedFilters);
    } else {
      const filterIndex = currentFilters.indexOf(selectedFilters);
      currentFilters.splice(filterIndex, 1);
    }
  }

  filtersFooter() {
    return (
      <div>
        <div className="map-filter-actions pull-right">
          <button className="btn btn-primary" type="button">Reset</button>&nbsp;
          <button className="btn btn-primary" onClick={this.queryDataset}>Done</button>
        </div>
      </div>
    );
  }

  queryDataset() {
    const _this = this;

    this.setState({
      ...this.state,
      loading: true,
      filtersViewable: false,
    });

    const queryString = 'filters[]=' + this.state.filters.join('&filters[]=');

    axios.get('/api/neighborhood/' + this.props.params.neighborhoodId + '/miscellaneous_data?' + queryString)
      .then(function (response) {
        _this.setState({
          ..._this.state,
          loading: false,
        });

        // debugger;  // commenting out so it doesn't appear in production
        _this.props.updateMap(formatResponse(response));
      })
      .catch(function (error) {
        _this.setState({
          loading: false,
        });

        toast(<p>We are sorry, but the application could not process your request.
          Please try again later.</p>, {
            type: toast.TYPE.INFO,
          });
      });
  }

  toggleReport() {
    this.setState({
      ...this.state,
      viewingReport: !this.state.viewingReport,
    });
  }

  filtersTooltip() {
    let className = 'map-filters';

    if (!this.state.filtersViewable) {
      className += ' hide';
    }

    return (
      <div className={className}>
        <div className="col-md-12">
          <h2>Miscellaneous Data</h2>
          <label>
            <input
              type="checkbox"
              value="sidewalk_issues"
              onChange={this.handleFilterChange}
            />&nbsp;
            Sidewalk Issues
          </label>
          <label>
            <input
              type="checkbox"
              value="problem_renters"
              onChange={this.handleFilterChange}
            />&nbsp;
            Potential Problem Renters
          </label>
        </div>
        {this.filtersFooter()}
      </div>
    );
  }

  loadingIndicator() {
    return (
      <span className="filters-loading">
        <i className="fa fa-refresh fa-large fa-spin"></i>
      </span>
    );
  }

  toggleFilters() {
    this.setState({
      ...this.state,
      filtersViewable: !this.state.filtersViewable
    });
  }

  filtersActivationButton() {
    return (
      <button
        className="btn btn btn-success filters-action"
        type="button"
        onClick={this.toggleFilters}
      >
        Filters
      </button>
    );
  }

  render() {
    return (
      <div>
        <div className="toolbar">
          {this.state.loading ? this.loadingIndicator() : this.filtersActivationButton()}
          {this.filtersTooltip()}
        </div>
      </div>
    );
  }
}

export default Miscellaenous;
