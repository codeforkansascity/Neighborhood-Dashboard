import { connect, Connector } from 'react-redux';
import Crime from '../components/crime';
import { neighborhoodReset, updateMap } from '../actions'

const mapStateToProps = (state) => {
  return ({
    neighborhoods: state.map.neighborhoods
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadDataSets: (neighborhoodId) => {
      dispatch(neighborhoodReset(neighborhoodId))
    },
    updateMap:(mapData) => {
      dispatch(updateMap(mapData))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Crime)
