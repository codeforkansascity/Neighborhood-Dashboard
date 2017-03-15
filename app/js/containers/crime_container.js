import { connect, Connector } from 'react-redux';
import Crime from '../components/crime';
import { neighborhoodReset, updateMap, updateLegend } from '../actions'

const mapStateToProps = (state) => {
  return ({
    neighborhoods: state.map.neighborhoods,
    map: state.map.map,
    legend: state.map.legend
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
    updateLegend: () => {
      dispatch(updateLegend('<ul><li><span class="legend-element" style="background: #626AB2;"></span>Persons</li></ul>'));
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Crime)
