import { default as React, PropTypes } from 'react'
import { render } from 'react-dom'

class Legend extends React.Component {
  constructor(props) {
    super(props);
    this.state = {legend: null}
  }

  componentDidUpdate() {
    if(this.props.legend) {
      if(this.state.legend) {
        this.state.legend.innerHTML = this.props.legend;
      }
      else if(this.props.legend && this.props.map && this.props.map.controls) {
        
        this.state.legend = document.createElement('nav');
        this.state.legend.className = 'legend clearfix';
        this.state.legend.innerHTML = this.props.legend;
        
        this.props.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(this.state.legend);
      }
    } else if(this.state.legend) {
      this.state.legend.innerHTML = null;
    }
  }

  render() {
    return false;
  }
}

export default Legend;
