import { connect, Connector } from 'react-redux';
import NeighborhoodMap from '../components/neighborhood_map';
import { cityOverview, neighborhoodHover, closeNeighborhoodLink } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.cityOverview;

  return ({
    neighborhood: currentState.neighborhood,
    neighborhoods: currentState.neighborhoods,
    coordinates: currentState.neighborhoods,
    polygons: currentState.polygons,
    selectedElement: currentState.selectedElement
  });
}

const mapDispatchToProps = (dispatch: Dispatch, ownProps) => {
  return {
    currentNeighborhoodChoice: (element) => {
      dispatch(neighborhoodHover(element));
    },
    closeNeighborhoodLink: () => {
      dispatch(closeNeighborhoodLink());
    },
    loadOverview: (response) => {
      dispatch(cityOverview(response))
    }
  }
}

const connector: Connector<OwnProps, Props> = connect(
  mapStateToProps,
  mapDispatchToProps
)

export default connector(NeighborhoodMap)
