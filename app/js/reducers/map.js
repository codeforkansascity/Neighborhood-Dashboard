const map = (state = {}, action) => {
  switch(action.type) {
    case 'UPDATE_MAP':
      var mapData = action.mapData;

      return {
        ... state,
        markers: mapData.markers,
        legend: mapData.legend,
        polygons: mapData.polygons,
        center: mapData.center,
        selectedElement: mapData.selectedElement
      };
    case 'UPDATE_SELECTED_ELEMENT':
      console.log('Updating Selected Element');
      console.log(action.element);
      return {
        ... state,
        selectedElement: action.element
      }
    default:
      return state;
  }
}

export default map;
