import { connect, Connector } from 'react-redux';
import CityOverview from '../components/city_overview';
import { cityOverview, neighborhoodHover, closeNeighborhoodLink } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  var currentState = state.selectedNeighborhood ? state.selectedNeighborhood : state.cityOverview;

  return ({
    neighborhood: currentState.neighborhood,
    neighborhoods: currentState.neighborhoods,
    coordinates: currentState.neighborhoods,
    polygons: currentState.polygons,
    selectedElement: currentState.selectedElement
  })
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

export default connector(CityOverview)
