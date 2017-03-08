import React from 'react';
import { render } from 'react-dom';
import axios from 'axios';

const CRIME_CODES = {
  ARSON: '200',
  ASSAULT: '13',
  ASSAULT_AGGRAVATED: '13A',
  ASSAULT_SIMPLE: '13B',
  ASSAULT_INTIMIDATION: '13C',
  BRIBERY: '510',
  BURGLARY: '220',
  FORGERY: '250',
  VANDALISM: '290',
  DRUG: '35',
  DRUG_NARCOTIC: '35A',
  DRUG_EQUIPMENT: '35B',
  EMBEZZLEMENT: '270',
  EXTORTION: '210',
  FRAUD: '26',
  FRAUD_SWINDLE: '26A',
  FRAUD_CREDIT_CARD: '26B',
  FRAUD_IMPERSONATION: '26C',
  FRAUD_WELFARE: '26D',
  FRAUD_WIRE: '26E',
  GAMBLING: '39',
  GAMBLING_BETTING: '39A',
  GAMBLING_OPERATING: '39B',
  GAMBLING_EQUIPMENT_VIOLATIONS: '39C',
  GAMBLING_TAMPERING: '39D',
  HOMICIDE: '09',
  HOMICIDE_NONNEGLIGENT_MANSLAUGHTER: '09A',
  HOMICIDE_NEGLIGENT_MANSLAUGHTER: '09B',
  HUMAN_TRAFFICKING: '64',
  HUMAN_TRAFFICKING_SEX_ACTS: '64A',
  HUMAN_TRAFFICKING_INVOLUNTARY_SERVITUDE: '64B',
  KIDNAPPING: '100',
  THEFT: '23',
  THEFT_POCKET_PICKING: '23A',
  THEFT_PURSE_SNATCHING: '23B',
  THEFT_SHOPLIFTING: '23C',
  THEFT_FROM_BUILDING: '23D',
  THEFT_FROM_THEFT_COINOPERATED_DEVICE: '23E',
  THEFT_MOTOR_VEHICLE: '23F',
  THEFT_MOTOR_VEHICLE_PARTS: '23G',
  THEFT_OTHER: '23H',
  MOTOR_VEHICLE_THEFT: '240',
  PORNOGRAPHY: '370',
  PROSTITUTION: '40',
  PROSTITUTION_BASE: '40A',
  PROSTITUTION_ASSISTANCE: '40B',
  PROSTITUTION_PURCHASING: '40C',
  ROBBERY: '120',
  SEX_OFFENSE: '11',
  SEX_OFFENSE_RAPE: '11A',
  SEX_OFFENSE_SODOMY: '11B',
  SEX_OFFENSE_ASSAULT_WITH_OBJECT: '11C',
  SEX_OFFENSE_FONDLING: '11D',
  SEX_OFFENSE_NONFORCIBLE: '36',
  SEX_OFFENSE_NONFORCIBLE_INCEST: '36A',
  SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE: '36B',
  STOLEN_PROPERTY: '280',
  WEAPON_LAW_VIOLATIONS: '520',
  BAD_CHECKS: '90A',
  CURFEW: '90B',
  DISORDERLY_CONDUCT: '90C',
  DRIVING_UNDER_INFLUENCE: '90D',
  DRUNKENNESS: '90E',
  FAMILY_OFFENSES_NON_VIOLENT: '90F',
  LIQUOR_LAW_VIOLATIONS: '90G',
  PEEPING_TOM: '90H',
  RUNAWAY: '90I',
  TRESSPASSING: '90J',
  OTHER: '90Z'
}

const CrimeCodeGroups = (code) => {
  switch(code) {
    case CRIME_CODES.ASSAULT:
      return [
        CRIME_CODES.ASSAULT_AGGRAVATED,
        CRIME_CODES.ASSAULT_SIMPLE,
        CRIME_CODES.ASSAULT_INTIMIDATION
      ];
    case CRIME_CODES.DRUG:
      return [
        CRIME_CODES.DRUG_NARCOTIC
      ];
    case CRIME_CODES.FRAUD:
      return [
        CRIME_CODES.FRAUD_SWINDLE,
        CRIME_CODES.FRAUD_CREDIT_CARD,
        CRIME_CODES.FRAUD_IMPERSONATION,
        CRIME_CODES.FRAUD_WELFARE,
        CRIME_CODES.FRAUD_WIRE
      ];
    case CRIME_CODES.GAMBLING:
      return [
        CRIME_CODES.GAMBLING_BETTING,
        CRIME_CODES.GAMBLING_OPERATING,
        CRIME_CODES.GAMBLING_EQUIPMENT_VIOLATIONS,
        CRIME_CODES.GAMBLING_TAMPERING
      ];
    case CRIME_CODES.HOMICIDE:
      return [
        CRIME_CODES.HOMICIDE_NONNEGLIGENT_MANSLAUGHTER,
        CRIME_CODES.HOMICIDE_NEGLIGENT_MANSLAUGHETER
      ];
    case CRIME_CODES.HUMAN_TRAFFICKING:
      return [
        CRIME_CODES.HUMAN_TRAFFICKING_SEX_ACTS,
        CRIME_CODES.HUMAN_TRAFFICKING_INVOLUNTARY_SERVITUDE
      ];
    case CRIME_CODES.THEFT:
      return [
        CRIME_CODES.THEFT_POCKET_PICKING,
        CRIME_CODES.THEFT_PURSE_SNATCHING,
        CRIME_CODES.THEFT_SHOPLIFTING,
        CRIME_CODES.THEFT_FROM_BUILDING,
        CRIME_CODES.THEFT_FROM_THEFT_COINOPERATED_DEVICE,
        CRIME_CODES.THEFT_MOTOR_VEHICLE,
        CRIME_CODES.THEFT_MOTOR_VEHICLE_PARTS,
        CRIME_CODES.THEFT_OTHER,
        CRIME_CODES.MOTOR_VEHICLE_THEFT
      ];
    case CRIME_CODES.PROSTITUTION:
      return [
        CRIME_CODES.PROSTITUTION_BASE,
        CRIME_CODES.PROSTITUTION_ASSISTANCE,
        CRIME_CODES.PROSTITUTION_PURCHASING
      ];
    case CRIME_CODES.SEX_OFFENSE:
      return [
        CRIME_CODES.SEX_OFFENSE_RAPE,
        CRIME_CODES.SEX_OFFENSE_SODOMY,
        CRIME_CODES.SEX_OFFENSE_ASSAULT_WITH_OBJECT,
        CRIME_CODES.SEX_OFFENSE_FONDLING,
        CRIME_CODES.SEX_OFFENSE_NONFORCIBLE,
        CRIME_CODES.SEX_OFFENSE_NONFORCIBLE_INCEST,
        CRIME_CODES.SEX_OFFENSE_NONFORCIBLE_STATUATORY_RAPE
      ];
    default:
      return [code];
  }
}

class Crime extends React.Component {
  constructor(props) {
    super(props);
    console.log(props)
    this.state = {
      filters: [],
      filtersViewable: false
    }
    
    this.handleFilterChange = this.handleFilterChange.bind(this);
    this.toggleFilters = this.toggleFilters.bind(this);
    this.queryDataset = this.queryDataset.bind(this);
  }
  componentDidMount() {
    this.props.loadDataSets(this.props.routeParams.neighborhoodId);
  }

  toggleFilters() {
    this.setState({
      ...this.state,
      filtersViewable: !this.state.filtersViewable
    });
  }

  handleFilterChange(event) {
    var currentFilters = this.state.filters,
        crimeCodes = CrimeCodeGroups(event.currentTarget.value),
        filterIsActive = event.currentTarget.checked;

    crimeCodes.forEach(function(code) {
      if(filterIsActive) {
        currentFilters.push(code);
      } else {
        var filterIndex = currentFilters.indexOf(code);
        currentFilters.splice(filterIndex, 1);
      }
    });

    console.log(this.state.filters);
  }

  filterInputs(groups, crimeObject) {
    return (
      <div className="row">
        {groups.map(function(group, index) {
            var groupRows = group.map(function(currentFilter) {
              return (
                <label>
                  <input type="checkbox" value={currentFilter.value} onChange={crimeObject.handleFilterChange}/>
                  {currentFilter.label}
                </label>
              )
            })

            return (
              <div className="col-md-6">
                {groupRows}
              </div>
            );
          })
        }
      </div>
    );
  }

  personCrimes() {
    return (
      <div className="col-md-2">
        <h2>Person</h2>
        <label>
          <input type="checkbox" value={CRIME_CODES.ASSAULT} onChange={this.handleFilterChange}/>
          Assault
        </label>
        <label>
          <input type="checkbox" value={CRIME_CODES.HOMICIDE} onChange={this.handleFilterChange}/>
          Homicide
        </label>
        <label>
          <input type="checkbox" value={CRIME_CODES.SEX_OFFENSE_FORCIBLE} onChange={this.handleFilterChange}/>
          Sex Offense, Forcible
        </label>
        <label>
          <input type="checkbox" value={CRIME_CODES.SEX_OFFENSE_NON_FORCIBLE} onChange={this.handleFilterChange}/>
          Sex Offense, Non Forcible
        </label>
      </div>
    )
  }

  propertyCrimes() {
    var _this = this;

    var groups = [
      [
        {value: CRIME_CODES.ARSON, label: 'Arson'},
        {value: CRIME_CODES.BURGLARY, label: 'Burglary'},
        {value: 'counterfeit', label: 'Counterfeiting'},
        {value: CRIME_CODES.EMBEZZLEMENT, label: 'Embezzlement'},
        {value: CRIME_CODES.EXTORTION, label: 'Extortion'},
        {value: CRIME_CODES.FRAUD, label: 'Fraud'}
      ],
      [
        {value: CRIME_CODES.MOTOR_VEHICLE_THEFT, label: 'Motor Vehicle Theft'},
        {value: CRIME_CODES.ROBBERY, label: 'Robbery'},
        {value: CRIME_CODES.STOLEN_PROPERTY, label: 'Stolen Property'},
        {value: CRIME_CODES.THEFT, label: 'Theft'},
        {value: CRIME_CODES.VANDALISM, label: 'Vandalism'},
      ]
    ];

    return(
      <div className="col-md-5">
        <h2>Property</h2>
        {this.filterInputs(groups, _this)}
      </div>
    );
  }

  societyCrimes() {
    var _this = this;

    var groups = [
      [
        {value: CRIME_CODES.BAD_CHECKS, label: 'Bad Checks'},
        {value: CRIME_CODES.CURFEW, label: 'Curfew & Loitering'},
        {value: CRIME_CODES.DISORDERLY_CONDUCT, label: 'Disorderly Conduct'},
        {value: CRIME_CODES.DUI, label: 'DUI'},
        {value: CRIME_CODES.DRUNKNESS, label: 'Drunkenness'},
        {value: 'domestic', label: 'Domestic Nonviolent'}
      ],
      [
        {value: CRIME_CODES.GAMBLING, label: 'Motor Vehicle Theft'},
        {value: CRIME_CODES.PORNOGRAPHY, label: 'Robbery'},
        {value: CRIME_CODES.LIQUOR_LAW_VIOLATIONS, label: 'Liquor Law Violation'},
        {value: CRIME_CODES.TRESSPASSING, label: 'Trespassing'}
      ]
    ];
    
    return(
      <div className="col-md-5">
        <h2>Property</h2>
        {this.filterInputs(groups, _this)}
      </div>
    );
  }

  filtersFooter() {
    return (
      <div>
        <div className="map-filter-actions pull-right">
          <button className="btn btn-primary" type="button">Reset</button>
          <button className="btn btn-primary" onClick={this.queryDataset}>Done</button>
        </div>
      </div>
    );
  }

  queryDataset() {
    var _this = this;

    this.setState({
      ...this.state,
      loading: true,
      filtersViewable: false
    });

    axios.get('/api/neighborhood/' + this.props.routeParams.neighborhoodId + '/crime?crime_codes[]=' + this.state.filters.join('&crime_codes[]='))
      .then(function(response) {
        _this.setState({
          ..._this.state,
          loading: false
        });
      })
      .then(function(error) {
      })
  }

  filtersTooltip() {
    return(
      <div className="map-filters">
        {this.personCrimes()}
        {this.propertyCrimes()}
        {this.societyCrimes()}
        {this.filtersFooter()}
      </div>
    );
  }

  loadingIndicator() {
    return (
      <span className="pull-right">
        <i className="fa fa-refresh fa-large fa-spin"></i>
      </span>
    );
  }

  filtersActivationButton() {
    return (
      <button className="btn btn btn-success pull-right" type="button" onClick={this.toggleFilters}>
        Filters
      </button>
    )
  }

  render() {
    return (
      <div>
        <nav className={"navbar sub-data-nav"}>
          <ul id="neighborhood-sub-tabs" className={"navbar-nav nav"}>
            <li role="presentation">
              <a role="tab">
                Open Report
              </a>
            </li>
          </ul>
        </nav>
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
            {this.state.loading ? this.loadingIndicator() : this.filtersActivationButton()}
          </form>
        </div>
        {this.state.filtersViewable && this.filtersTooltip()}
      </div>
    )
  }
}

export default Crime;
