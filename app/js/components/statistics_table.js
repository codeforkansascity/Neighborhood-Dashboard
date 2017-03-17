import React from 'react'
import { render } from 'react-dom'

class StatisticsTable extends React.Component {
  constructor(props) {
    super(props)
    this.state.data = data;
  }

  componentWillReceiveProps() {
    this.setState({modalIsOpen: false});
  }

  openModal(e) {
    e.preventDefault();
    this.setState({modalIsOpen: true});
  }

  render() {
    var data = this.state.data;

    return (
      <table className="statistics-table">
        <thead>
        </thead>
      </table>
    )
  }

}

export default StatisticsTable;
