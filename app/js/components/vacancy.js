import { default as React, PropTypes } from 'react'
import { render } from 'react-dom'

class Vacancy extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      filters: [],
      filtersViewable: false
    }

    this.toggleFilters = this.toggleFilters.bind(this);
  }

  componentDidUpdate() {}

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
              <input type="checkbox"/>
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
            <button className="btn btn-primary">Done</button>
          </div>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div className="toolbar">
        <form className="form-inline">
          <div className="form-group">
            <input type="date" name="start_date" className="form-control"/>
            <label>Start Date</label>
          </div>
          <div className="form-group">
            <input type="date" name="end_date" className="form-control"/>
            <label>End Date</label>
          </div>
          <button className="btn btn btn-success pull-right" type="button" onClick={this.toggleFilters}>
            Filters
          </button>
          {this.mapFilters()}
        </form>
      </div>
    );
  }
}

export default Vacancy;
