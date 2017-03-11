import { connect, Connector } from 'react-redux';
import Crime from '../components/crime';
import { neighborhoodReset, updateMap } from '../actions'

const formattedCrimeData = (data) => {
  markers = data.map(function(marker) {
    return {
      position: {
        lng: marker.geometry.coordinates[1],
        lat: marker.geometry.coordinates[0]
      }
    }
  })

  return {
    markers: markers
  }
}

const mapStateToProps = (state) => {
  var currentState = state.map;

  return ({
    markers: currentState.markers,
    legend: currentState.legend,
    polygons: currentState.polygons,
    position: currentState.center,
    selectedElement: currentState.selectedElement,
    neighborhoods: state.neighborhoods
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadDataSets: (neighborhoodId) => {
      dispatch(neighborhoodReset(neighborhoodId))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  null,
  mapDispatchToProps
)

export default connector(Crime)
