import { default as React, PropTypes } from 'react'
import { render } from 'react-dom'

class Legend extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidUpdate() {
    if(this.props.map && this.props.map.controls) {
      var legendMarkup =
          <nav className='legend clearfix'><ul><li>
                <span class="legend-element" style={{backgroundColor: '#626AB2'}}></span>Person
              </li>
              <li>
                <span class="legend-element" style={{backgroundColor: '#313945'}}></span>Property
              </li>
              <li>
                <span class="legend-element" style={{backgroundColor: '#6B7D96'}}></span>Society
              </li>
              <li>
                <span class="legend-element" style={{border: '#000 solid 1px', backgroundColor: '#FFFFFF'}}></span>Uncategorized
              </li>
            </ul>
          </nav>


      var navigationLegend = document.createElement('nav');
      navigationLegend.className = 'legend clearfix';

      var elementsList = document.createElement('ul');

      var firstItem = document.createElement('li');
      firstItem.innerHTML = '<span class="legend-element" style="background: #626AB2;"></span> Persons';

      elementsList.appendChild(firstItem);
      navigationLegend.appendChild(elementsList);

      this.props.map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(navigationLegend);
    }
  }

  componentWillReceiveProps() {
    console.log('Legend Props');
    console.log(this.props);
  }

  render() {
    return false;
  }
}

export default Legend;
