import React from 'react';
import { connect, Connector } from 'react-redux';
import CityOverview from '../components/city_overview';
import { updateMap, cityOverview } from '../actions';

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var mapState = state.map;

  return ({
    neighborhoods: mapState.neighborhoods
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadOverview: (response) => {
      dispatch(cityOverview())
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(CityOverview)
