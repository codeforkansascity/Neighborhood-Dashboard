import { connect, Connector } from 'react-redux';
import Map from '../components/map';
import { updateMap, updateSelectedElement, fetchNeighborhoods } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.map;
  console.log('Mapping Center');
  console.log(currentState.center);

  return ({
    markers: currentState.markers,
    legend: currentState.legend,
    polygons: currentState.polygons || [],
    center: currentState.center,
    selectedElement: currentState.selectedElement,
    neighborhoods: currentState.neighborhoods
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    updateSelectedElement: (element) => {
      dispatch(updateSelectedElement(element));
    },
    loadNeighborhoods: (data) => {
      dispatch(fetchNeighborhoods(data))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Map)
