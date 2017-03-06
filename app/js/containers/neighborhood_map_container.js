import { connect, Connector } from 'react-redux';
import NeighborhoodMap from '../neighborhood_map';
import { cityOverview, neighborhoodHover, closeNeighborhoodLink } from '../actions'

type OwnProps = {
  filter: {}
}

const mapStateToProps = (state) => {
  return ({
    neighborhood: state.cityOverview.neighborhood,
    neighborhoods: state.cityOverview.neighborhoods,
    coordinates: state.cityOverview.neighborhoods,
    polygons: state.cityOverview.polygons,
    selectedElement: state.cityOverview.selectedElement
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

export default connector(NeighborhoodMap)
