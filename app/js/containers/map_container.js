import { connect, Connector } from 'react-redux';
import Map from '../components/map';
import { updateMap, updateSelectedElement, fetchNeighborhoods, addMap } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.map;

  return ({
    markers: currentState.markers,
    polygons: currentState.polygons || [],
    neighborhoodPolygon: currentState.neighborhoodPolygon,
    center: currentState.center,
    selectedElement: currentState.selectedElement,
    neighborhoods: currentState.neighborhoods,
    map: currentState.map
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    updateSelectedElement: (element) => {
      dispatch(updateSelectedElement(element));
    },
    loadNeighborhoods: (data) => {
      dispatch(fetchNeighborhoods(data))
    },
    addMap: (map) => {
      dispatch(addMap(map))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Map)
