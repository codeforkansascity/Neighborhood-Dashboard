import React from 'react';
import { connect, Connector } from 'react-redux';
import CityOverview from '../components/city_overview';
import { updateMap } from '../actions'

type OwnProps = {
  filter: {}
}

const formatOverviewResponse = (response) => {
  var validNeighborhoods = response["data"]["features"].filter((neighborhood) => {
    return neighborhood['properties']['nbhname'];
  });

  var polygons = validNeighborhoods.map(function(neighborhood) {
    var paths = neighborhood["geometry"]["coordinates"][0][0].map (function(coordinates) {
      return {lng: coordinates[0], lat: coordinates[1]}
    });

    return {
      type: 'polygon',
      paths: paths,
      objectid: neighborhood['properties']['objectid'], 
      windowContent: 
        <div>
          <p>{neighborhood.properties.nbhname}</p>
          <a className={'btn btn-primary'} onClick={() => {pushState('/neighborhood/' + neighborhood.properties.objectid + '/crime')}}>Go to Neighborhood</a>
        </div>
    };
  });

  return {
    polygons: polygons,
    markers: [],
    selectedElements: null,
  }
}

const mapStateToProps = (state) => {
  return ({
    neighborhood: state.selectedNeighborhood.neighborhoods,
    datasets: state.selectedNeighborhood.datasets,
    polygons: []
  })
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadOverview: (response) => {
      dispatch(updateMap(formatOverviewResponse(response)))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(CityOverview)
