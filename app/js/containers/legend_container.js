import { connect, Connector } from 'react-redux';
import Legend from '../components/legend';
import { updateMap, updateSelectedElement, fetchNeighborhoods, addMap } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.map;

  return ({
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

export default connector(Legend)
