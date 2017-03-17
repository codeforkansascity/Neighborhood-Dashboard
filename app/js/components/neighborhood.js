import { default as React, PropTypes } from 'react'
import { render } from 'react-dom'

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
        {this.props.children}
      </div>
    )
  }
}

export default Neighborhood;
