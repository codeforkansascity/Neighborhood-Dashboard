import { connect, Connector } from 'react-redux';
import Map from '../components/map';
import { updateMap, updateSelectedElement } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.map;

  return ({
    markers: currentState.markers,
    legend: currentState.legend,
    polygons: currentState.polygons,
    position: currentState.center,
    selectedElement: currentState.selectedElement
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    updateSelectedElement: (element) => {
      dispatch(updateSelectedElement(element));
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Map)
