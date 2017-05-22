import { connect, Connector } from 'react-redux';
import Neighborhood from '../components/neighborhood';
import { neighborhoodReset, updateMap, updateLegend } from '../actions/index'

const mapStateToProps = (state) => {
  return ({
    neighborhoods: state.map.neighborhoods,
    neighborhood: state.map.neighborhood
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
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Neighborhood)
