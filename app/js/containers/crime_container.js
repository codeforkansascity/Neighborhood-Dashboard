import { connect, Connector } from 'react-redux';
import Crime from '../components/crime';
import { cityOverview, neighborhoodHover, neighborhoodReset, closeNeighborhoodLink, switchNeighborhood } from '../actions'

const mapStateToProps = (state) => {
  return ({
    neighborhood: state.selectedNeighborhood.neighborhoods,
    datasets: state.selectedNeighborhood.datasets,
    polygons: []
  })
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    loadDataSets: (neighborhoodId) => {
      console.log('Loading datasets');
      console.log(this);
      dispatch(neighborhoodReset(neighborhoodId))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(Crime)
