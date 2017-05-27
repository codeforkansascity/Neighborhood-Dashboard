import { connect, Connector } from 'react-redux';
import Legend from '../components/legend';
import { updateMap, updateSelectedElement, fetchNeighborhoods, addMap } from '../actions/index'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  return ({
    map: state.map.map,
    legend: state.Legend.legend
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadDataSets: (neighborhoodId) => {
      dispatch(neighborhoodReset(neighborhoodId))
    },
    updateMap:(mapData) => {
      debugger;
      dispatch(updateMap(mapData))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(mapStateToProps, mapDispatchToProps)

export default connector(Legend)
