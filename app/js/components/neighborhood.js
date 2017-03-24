import { default as React, PropTypes } from 'react'
import { render } from 'react-dom'
import { Link } from 'react-router'

class Neighborhood extends React.Component {
  constructor(props) {
    super(props);
    this.state = {legend: null}
  }

  componentDidMount() {
    this.props.loadDataSets(this.props.params.neighborhoodId);
  }

  componentWillUpdate(nextProps, State) {
    this.props.loadDataSets(this.props.params.neighborhoodId);
  }

  componentDidUpdate() {
    this.props.loadDataSets(this.props.params.neighborhoodId);
  }

  componentWillReceiveProps() {
    this.props.loadDataSets(this.props.params.neighborhoodId);
  }

  render() {
    return (
      <div className="neighborhood-content">
        <h1 className="neighborhood-title">{this.props.neighborhood ? this.props.neighborhood.properties.nbhname : ''}</h1>
        <ul className="nav nav-tabs neighborhood-nav">
          <li><Link to={"/neighborhood/" + this.props.params.neighborhoodId + "/crime"} activeClassName='active'>Crime</Link></li>
          <li><Link to={"/neighborhood/" + this.props.params.neighborhoodId + "/vacancy"} activeClassName='active'>Vacancies</Link></li>
          <li><Link to={"/neighborhood/" + this.props.params.neighborhoodId + "/demographics"} activeClassName='active'>Demographics</Link></li>
        </ul>
        {this.props.children}
      </div>
    )
  }
}

export default Neighborhood;
