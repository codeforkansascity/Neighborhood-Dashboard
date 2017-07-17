import { connect, Connector } from 'react-redux';
import Crime from '../components/crime';
import { neighborhoodReset, updateMap, updateLegend } from '../actions/index'
import InfoBox from 'react-google-maps/lib/addons/InfoBox';

const mapStateToProps = (state) => {
  return ({
    neighborhoods: state.map.neighborhoods,
    map: state.map.map,
    legend: state.map.legend,
    neighborhood: state.map.neighborhood
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadDataSets: (neighborhoodId) => {
      dispatch(neighborhoodReset(neighborhoodId))
    },
    updateMap:(mapData) => {
      dispatch(updateMap(mapData))
    },
    updateLegend: (legend) => {
      dispatch(updateLegend(legend));
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Crime)
