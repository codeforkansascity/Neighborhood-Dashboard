import { default as React, PropTypes } from 'react';
import { render } from 'react-dom';
import axios from 'axios';

const formatResponse = (response) => {
  var markers = response.data
    .filter(function(dataPoint) {
      return dataPoint.geometry.type === 'Point';
    })
    .map(function(dataPoint) {
      return(
        {
          type: 'marker',
          position: {
            lat: dataPoint.geometry.coordinates[1],
            lng: dataPoint.geometry.coordinates[0]
          },
          icon: {
            path: google.maps.SymbolPath.CIRCLE,
            scale: 5,
            fillColor: dataPoint.properties.color,
            fillOpacity: 0.9,
            strokeWeight: 0
          },
          defaultAnimation: 2,
          windowContent: dataPoint.properties.disclosure_attributes.map(
            (attribute) => <div dangerouslySetInnerHTML={{__html: attribute}}/>
          )
        }
      )
    });

  var polygons = response.data
    .filter(function(dataPoint) {
      return dataPoint.geometry.type === 'Polygon';
    })
    .map(function(dataPoint) {
      return (
        {
          type: 'polygon',
          paths: dataPoint.geometry.coordinates,
          selectablePolygon: true,
          windowContent: dataPoint.properties.disclosure_attributes.map(
            (attribute) => <div dangerouslySetInnerHTML={{__html: attribute}}/>
          )
        }
      )
    });

  return {markers: markers, polygons: polygons};
}

const VACANCY_CODES = {
  LEGALLY_ABANDONED: {
    ALL_ABANDONED: 'all_abandoned',
    ONE_THREE_YEARS: 'one_three_years_violation_length',
    THREE_YEARS_PLUS: 'three_years_plus_violation_length',
    BOARDED_LONGTERM: 'boarded_longterm',
    VACANT_REGISTRY_FAILURE: 'vacant_registry_failure',
    DANGEROUS_BUILDING: 'dangerous_building'
  },
  VACANT_INDICATOR: {
    TAX_DELINQUENT: 'tax_delinquent',
    DANGEROUS_BUILDING: 'dangerous_building',
    BOARDED_LONGTERM: 'boarded_longterm',
    VACANT_REGISTRY_FAILURE: 'vacant_registry_failure',
    OPEN_THREE_ELEVEN: 'open',
    VACANT_STRUCTURE: 'vacant_structure',
    ALL_PROPERTY_VIOLATIONS: 'all_property_violations',
    REGISTERED_VACANT: 'registered_vacant',
    ALL_VACANT_LOTS: 'all_vacant_filters',
    DEMO_NEEDED: 'demo_needed',
    FORECLOSED: 'foreclosed'
  }
}

class Vacancy extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      filters: [],
      filtersViewable: false
    }

    this.toggleFilters = this.toggleFilters.bind(this);
    this.handleFilterChange = this.handleFilterChange.bind(this);
    this.queryDataset = this.queryDataset.bind(this);
  }

  handleFilterChange(event) {
    var currentFilters = this.state.filters,
        vacancyCode = event.currentTarget.value,
        filterIsActive = event.currentTarget.checked;

    if(filterIsActive) {
      currentFilters.push(vacancyCode);
    } else {
      var filterIndex = currentFilters.indexOf(vacancyCode);
      currentFilters.splice(filterIndex, 1);
    }
  }

  queryDataset() {
    var _this = this;

    this.setState({
      ...this.state,
      loading: true,
      filtersViewable: false
    });

    axios.get('/api/neighborhood/' + this.props.params.neighborhoodId + '/vacancy?filters[]=' + this.state.filters.join('&filters[]='))
      .then(function(response) {
        var legend = 
        `<ul>
          <li><span class="legend-element" style="background-color: #626AB2;"></span>Person</li>
          <li><span class="legend-element" style="background-color: #313945;"></span>Property</li>
          <li><span class="legend-element" style="background-color: #6B7D96;"></span>Society</li>
          <li><span class="legend-element" style="border: #000 solid 1px; background-color: #FFFFFF;"></span>Uncategorized</li>
        </ul>`

        _this.setState({
          ..._this.state,
          loading: false
        });

        _this.props.updateMap(formatResponse(response));
        _this.props.updateLegend(legend);
      })
      .then(function(error) {
        console.log(error);
      })
  }

  toggleFilters() {
    this.setState({
      ... this.state,
      filtersViewable: !this.state.filtersViewable
    })
  }

  mapFilters() {
    var className = 'map-filters'

    if(!this.state.filtersViewable) {
      className += ' hide'
    }

    return (
      <div className={className}>
        <p>Only one category of data can be displayed at once. Selecting data in one category will disable the other column.</p>
        <div className="row">
          <div className="col-md-6">
            <h2>
              Legally Abandoned
              <span className="fa fa-info-circle pull-right tooltipster" aria-hidden="true" title="Under the Missouri Abandoned Housing Act, a lawsuit maybe filed on properties that are legally abandoned allowing new owners to purchase the property. To be considered legally abandoned, a property must be vacant for at least 6 months, tax delinquent, and have open code violations."></span>
            </h2>
            <label>
              <input type="checkbox" value={VACANCY_CODES.LEGALLY_ABANDONED.ALL_ABANDONED} onChange={this.handleFilterChange}/>
              View all Legally Abandoned Projects
            </label>
            <h4>Tax Delinquency (Jackson County)</h4>
            <p>
              Tax Delinquent 1-3 Years
            </p>
            <p>
              Tax Delinquent 3+ Years
            </p>
            <h4>Code Violations (City of KCMO, KCMO 311)</h4>
            <p>
              1-3 Violations
            </p>
            <p>
              3+ Violations
            </p>
            <h4>Vacant Related Violations</h4>
            <p>
              Failure to Register as Vacant (City of KCMO)
            </p>
            <p>
              Vacant Structure Called In (KCMO 311)
            </p>
            <p>
              Registered As Vacant (City of KCMO)
            </p>
            <p>
              Dangerous Building (City of KCMO)
            </p>
            <p>
              Vacant and Boarded (City of KCMO)
            </p>
          </div>
          <div className="col-md-6">
            <h2>
              Vacant Indicators
              <span className="fa fa-info-circle pull-right tooltipster" aria-hidden="true" title="Because there is not a fully complete list of vacant properties and no easy way to create one - anyone interested in determining whether a property is vacant must instead look to indicators of vacancy Note that interpreting indicatiors is not 100% accurate and even when a property appears vacant, it may still be occupied."></span>
            </h2>
            <label>
              <input type="checkbox"/>
              Vacant Lot - Land Bank Property (City of KCMO)
            </label>
            <label>
              <input type="checkbox"/>
              Demo Needed - Land Bank Property (KCMO Land Bank Property)
            </label>
            <label>
              <input type="checkbox"/>
              Registered Vacant (City of KCMO)
            </label>
            <label>
              <input type="checkbox"/>
              Failure to Register as Vacant (City of KCMO)
            </label>
            <label>
              <input type="checkbox"/>
              Vacant Structure (KCMO 311)
            </label>
            <label>
              <input type="checkbox"/>
              311 Open Cases (KCMO 311)
            </label>
            <label>
              <input type="checkbox"/>
              KCMO Dangerous Buildings (City of KCMO)
            </label>
            <label>
              <input type="checkbox"/>
              Vacant and Boarded (City of KCMO)
            </label>
            <label>
              <input type="checkbox"/>
              Tax Delinquent (Jackson County)
            </label>
            <label>
              <input type="checkbox"/>
              All Property Violations (KCMO 311)
            </label>
            <div className="form-group">
              <input type="date" name="start_date" className="form-control" />
              <label>Start Date</label>
            </div>
            <div className="form-group">
              <input type="date" name="end_date" className="form-control" />
              <label>End Date</label>
            </div>
          </div>
        </div>
        <div>
          <div className="map-filter-actions pull-right">
            <button className="btn btn-primary" type="button">Reset</button>
            <button className="btn btn-primary" onClick={this.queryDataset}>Done</button>
          </div>
        </div>
      </div>
    )
  }

  filtersActivationButton() {
    return (
      <button className="btn btn btn-success pull-right" type="button" onClick={this.toggleFilters}>
        Filters
      </button>
    )
  }

  loadingIndicator() {
    return (
      <span className="pull-right">
        <i className="fa fa-refresh fa-large fa-spin"></i>
      </span>
    );
  }

  render() {
    return (
      <div className="toolbar">
        <form className="form-inline" onSubmit={(e) => e.preventDefault()}>
          <div className="form-group">
            <input type="date" name="start_date" className="form-control"/>
            <label>Start Date</label>
          </div>
          <div className="form-group">
            <input type="date" name="end_date" className="form-control"/>
            <label>End Date</label>
          </div>
            {this.state.loading ? this.loadingIndicator() : this.filtersActivationButton()}
          {this.mapFilters()}
        </form>
      </div>
    );
  }
}

export default Vacancy;
