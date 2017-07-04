import { connect, Connector } from 'react-redux';
import Map from '../components/map';
import { updateMap, updateSelectedMapElement, fetchNeighborhoods, addMap, cityOverview } from '../actions/index'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.map;

  return ({
    markers: currentState.markers,
    polygons: currentState.polygons,
    selectedNeighborhood: currentState.selectedNeighborhood,
    center: currentState.center,
    selectedMapElement: currentState.selectedMapElement,
    neighborhoods: currentState.neighborhoods,
    map: currentState.map
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    updateSelectedMapElement: (element) => {
      dispatch(updateSelectedMapElement(element));
    },
    loadNeighborhoods: (data) => {
      dispatch(fetchNeighborhoods(data))
    },
    addMap: (map) => {
      dispatch(addMap(map))
    },
    loadOverview: (response) => {
      dispatch(cityOverview())
    },
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Map)
