import React from 'react'
import { render } from 'react-dom'

class MyApp extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return <p>Hello {this.props.name}!</p>;
  }
}

MyApp.defaultProps = {
  name: 'asd'
};

export default MyApp;