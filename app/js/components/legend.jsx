import { default as React, PropTypes } from 'react';

class Legend extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      legend: null,
      legendCollapsed: false,
    };

    this.updateLegendCollapse = this.updateLegendCollapse.bind(this);
  }

  componentDidUpdate() {
    if (this.props.legend) {
      if (this.state.legend) {
        this.state.legendContent.innerHTML = '';

        if (!this.state.legendCollapsed) {
          this.state.legendContent.innerHTML = this.props.legend;
          this.state.legendToggle.innerHTML = 'Hide Legend';
        } else {
          this.state.legendToggle.innerHTML = 'Display Legend';
        }

        if (!this.state.legend.innerHTML) {
          this.state.legend.className = 'legend clearfix';
          this.state.legend.appendChild(this.state.legendToggle);
          this.state.legend.appendChild(this.state.legendContent);
        }
      } else if (this.props.legend && this.props.map && this.props.map.controls) {
        this.state.legendContent = document.createElement('div');
        this.state.legendContent.innerHTML = this.props.legend;
        this.state.legend = document.createElement('nav');
        this.state.legend.className = 'legend clearfix';
        this.state.legendToggle = this.getToggleElement();
        this.state.legend.appendChild(this.state.legendToggle);
        this.state.legend.appendChild(this.state.legendContent);
        this.props.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(this.state.legend);
      }
    } else if (this.state.legend) {
      this.state.legend.innerHTML = null;
      this.state.legend.className = '';
    }
  }

  getToggleElement() {
    var _this = this;

    const elementCreated = document.createElement('div');
    elementCreated.className = 'legend-toggle';
    elementCreated.innerHTML = 'Hide Legend';
    elementCreated.onclick = function () { _this.updateLegendCollapse(); };
    return elementCreated;
  }

  updateLegendCollapse() {
    this.setState({
      legendCollapsed: !this.state.legendCollapsed,
    });
  }

  render() {
    return false;
  }
}

export default Legend;
