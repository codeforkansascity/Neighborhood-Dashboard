import { default as React, PropTypes } from 'react';
import { render } from 'react-dom';
import axios from 'axios';
import ReactTooltip from 'react-tooltip';
import { toast } from 'react-toastify';

const formatResponse = (response) => {
  var markers = response.data
    .filter(function(dataPoint) {
      return dataPoint.geometry.type === 'Point' && dataPoint.geometry.coordinates[1] !== 0.0;
    })
    .map(function(dataPoint) {
      var iconStyle = {};

      if (dataPoint.properties.marker_style == 'circle') {
        iconStyle = {
          path: google.maps.SymbolPath.CIRCLE,
          scale: 5,
          fillColor: dataPoint.properties.color,
          fillOpacity: 0.9,
          strokeWeight: 0
        };
      } else {
        iconStyle = {
          path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z M -2,-30 a 2,2 0 1,1 4,0 2,2 0 1,1 -4,0',
          fillColor: dataPoint.properties.color,
          fillOpacity: 1,
          strokeColor: '#000',
          strokeWeight: 2,
          scale: 1,
        }
      }
      return(
        {
          type: 'marker',
          position: {
            lat: dataPoint.geometry.coordinates[1],
            lng: dataPoint.geometry.coordinates[0]
          },
          icon: iconStyle,
          defaultAnimation: 2,
          windowContent: dataPoint.properties.disclosure_attributes.map(
            (attribute) => <div dangerouslySetInnerHTML={{__html: attribute}}/>
          ),
          windowStyle: {
            overflow: 'auto',
            minHeight: '300px'
          }
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
          paths: dataPoint.geometry.coordinates[0].map(function(data) {
            return {lat: data[1], lng: data[0]}
          }),
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
    LANDBANK_VACANT_LOTS: 'landbank_vacant_lots',
    LANDBANK_VACANT_STRUCTURES: 'landbank_vacant_structures',
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
    var currentFilters = this.state.filters.splice(0),
        vacancyCode = event.currentTarget.value,
        filterIsActive = event.currentTarget.checked;

    if(filterIsActive) {
      currentFilters.push(vacancyCode);
    } else {
      var filterIndex = currentFilters.indexOf(vacancyCode);
      currentFilters.splice(filterIndex, 1);
    }

    this.setState({
      filters: currentFilters
    });
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
          <li><span class="legend-element" style="background-color: #CCC;"></span>Low Indication of Vacancy</li>
          <li><span class="legend-element" style="background-color: #888;"></span>Medium Indication of Vacancy</li>
          <li><span class="legend-element" style="background-color: #444;"></span>High Indication of Vacancy</li>
          <li><span class="legend-element" style="border: #000 solid 1px; background-color: #000;"></span>Very High Indication of Vacancy</li>
        </ul>
        <ul>
          <li>Circle - Vacant Building</li>
          <li>Polygon - Vacant Lot</li>
        </ul>`

        _this.setState({
          ..._this.state,
          loading: false
        });

        _this.props.updateMap(formatResponse(response));
        _this.props.updateLegend(legend);
      })
      .catch(function(error) {
        _this.setState({
          loading: false
        });

        toast(<p>We're sorry, but the application could not process your request. Please try again later.</p>, {
          type: toast.TYPE.INFO
        });
      });
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
        <div>
          <p className="col-md-12">Only one category of data can be displayed at once. Selecting data in one category will disable the other column.</p>
          <div className="col-md-6">
            <h2>
              Legally Abandoned
              <span className="fa fa-info-circle pull-right" data-tip data-for='legally-abandoned-info' data-event='click focus'></span>
              <ReactTooltip id='legally-abandoned-info' className="vacancy-desriptor">
                <p>Under the Missouri Abandoned Housing Act, a lawsuit maybe filed on properties that are legally abandoned allowing new owners to purchase the property. To be considered legally abandoned, a property must be vacant for at least 6 months, tax delinquent, and have open code violations.</p>
              </ReactTooltip>
            </h2>
            <label>
              <input type="checkbox" value={VACANCY_CODES.LEGALLY_ABANDONED.ALL_ABANDONED} onChange={this.handleFilterChange}/>&nbsp;
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
              Dangerous Building (City of KCMO)
            </p>
            <p>
              Vacant and Boarded (City of KCMO)
            </p>
          </div>
          <div className="col-md-6">
            <h2>
              Vacant Indicators
              <span className="fa fa-info-circle pull-right" data-tip data-for='vacant-indicator-info' data-event='click focus'></span>
              <ReactTooltip id='vacant-indicator-info' className="vacancy-desriptor">
                <p>Because there is not a fully complete list of vacant properties and no easy way to create one - anyone interested in determining whether a property is vacant must instead look to indicators of vacancy Note that interpreting indicatiors is not 100% accurate and even when a property appears vacant, it may still be occupied.</p>
              </ReactTooltip>
            </h2>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.LANDBANK_VACANT_STRUCTURES)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.LANDBANK_VACANT_STRUCTURES} onChange={this.handleFilterChange} />&nbsp;
              Vacant Building - Land Bank Property (City of KCMO)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.LANDBANK_VACANT_LOTS)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.LANDBANK_VACANT_LOTS} onChange={this.handleFilterChange} />&nbsp;
              Vacant Lot - Land Bank Property (City of KCMO)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.DEMO_NEEDED)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.DEMO_NEEDED} onChange={this.handleFilterChange} />&nbsp;
              Demo Needed - Land Bank Property (KCMO Land Bank Property)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.VACANT_REGISTRY_FAILURE)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.VACANT_REGISTRY_FAILURE} onChange={this.handleFilterChange} />&nbsp;
              Failure to Register as Vacant (City of KCMO)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.VACANT_STRUCTURE)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.VACANT_STRUCTURE} onChange={this.handleFilterChange} />&nbsp;
              Vacant Structure (KCMO 311)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.OPEN_THREE_ELEVEN)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.OPEN_THREE_ELEVEN} onChange={this.handleFilterChange} />&nbsp;
              311 Open Cases (KCMO 311)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.DANGEROUS_BUILDING)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.DANGEROUS_BUILDING} onChange={this.handleFilterChange} />&nbsp;
              KCMO Dangerous Buildings (City of KCMO)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.BOARDED_LONGTERM)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.BOARDED_LONGTERM} onChange={this.handleFilterChange} />&nbsp;
              Vacant and Boarded (City of KCMO)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.TAX_DELINQUENT)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.TAX_DELINQUENT} onChange={this.handleFilterChange} />&nbsp;
              Tax Delinquent (Jackson County)
            </label>
            <label>
              <input disabled={this.isVacancyFilterDisabled(VACANCY_CODES.VACANT_INDICATOR.ALL_PROPERTY_VIOLATIONS)} type="checkbox" value={VACANCY_CODES.VACANT_INDICATOR.ALL_PROPERTY_VIOLATIONS} onChange={this.handleFilterChange} />&nbsp;
              All Property Violations (KCMO 311)
            </label>
          </div>
        </div>
        <div>
          <div className="map-filter-actions pull-right">
            <button className="btn btn-primary" type="button">Reset</button>&nbsp;
            <button className="btn btn-primary" onClick={this.queryDataset}>Done</button>
          </div>
        </div>
      </div>
    )
  }

  isVacancyFilterDisabled(value) {
    if (
      this.state.filters.includes(VACANCY_CODES.LEGALLY_ABANDONED.ALL_ABANDONED) || 
      (this.state.filters.length >= 3 && !this.state.filters.includes(value))) {
      return true;
    } else {
      return false;
    }
  }

  filtersActivationButton() {
    return (
      <button className="btn btn btn-success filters-action" type="button" onClick={this.toggleFilters}>
        Filters
      </button>
    )
  }

  loadingIndicator() {
    return (
      <span className="filters-loading">
        <i className="fa fa-refresh fa-large fa-spin"></i>
      </span>
    );
  }

  render() {
    return (
      <div className="toolbar">
        {this.state.loading ? this.loadingIndicator() : this.filtersActivationButton()}
        {this.mapFilters()}
      </div>
    );
  }
}

export default Vacancy;
