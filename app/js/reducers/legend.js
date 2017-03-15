import React from 'react';
import { render } from 'react-dom';

const Legend = (state = {}, action) => {
  switch (action.type) {
    case 'UPDATE_LEGEND':
      return {
        ... state,
        legend: action.legend
      }
    default:
      return state
  }
}

export default Legend;
