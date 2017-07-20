import React from 'react';
import ReactDOM from 'react-dom';
import Modal from 'react-modal';
import Select2 from 'react-select2-wrapper';
import { browserHistory } from 'react-router';

class NeighborhoodSearch extends React.Component {

  neighborhoodSelect(e) {
    e.preventDefault();
    browserHistory.replace('/neighborhood/' + this.value + '/crime');
  }

  render() {
    const _this = this;

    return (
      <Select2
        onSelect={this.neighborhoodSelect}
        options={{
          placeholder: 'Search by Neighborhood',
          width: '15em',
          ajax: {
            url: '/api/neighborhood/search',
            delay: 250,
            dataType: 'json',
            data: function (params) {
              return {
                search_neighborhood: params.term,
              };
            },
            processResults: function (data, params) {
              const formattedResponse = data.map(function (element) {
                return { id: element.id, text: element.name };
              });

              return { results: formattedResponse };
            },
            cache: true,
          },
        }}
      />
    );
  }
}

export default NeighborhoodSearch;
