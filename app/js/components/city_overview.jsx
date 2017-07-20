import React from 'react';
import { render } from 'react-dom';

class CityOverview extends React.Component {

  componentDidMount(nextProps, State) {
    this.props.loadOverview();
    this.props.updateLegend();
  }

  componentWillUpdate(nextProps, State) {
    this.props.loadOverview();
    this.props.updateLegend();
  }

  render() {
    return (
      <div></div>
    );
  }
}

export default CityOverview;
