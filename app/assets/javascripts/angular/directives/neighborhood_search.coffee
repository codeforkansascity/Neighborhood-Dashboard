angular.module('neighborhoodstat').directive('neighborhoodSearch',
  [
    '$location',
    ($location) ->
      return {
        link: ($scope, element, attrs)->
          element.attr('id', 'neighborhood-search');
          element.attr('name', 'search_neighborhood');
          element.attr('class', 'form-control');
          element.attr('placeholder', 'Enter neighborhood name');

          $('#neighborhood-search').select2(
            {
              minimumInputLength: 1,
              allowClear: true,
              placeholder: {
                id: '-1',
                placeholder: 'Search for Neighborhood'
              },
              ajax: {
                url: Routes.neighborhood_search_api_neighborhood_index_path(),
                delay: 250,
                dataType: 'json',
                data: (params) ->
                  return {
                    search_neighborhood: params.term
                  }
                ,
                processResults: (data, params) ->
                  formattedResponse = data.map (element) ->
                    {id: element.id, text: element.name}

                  return {results: formattedResponse}
                ,
                cache: true
              }
            }
          );

          $('#neighborhood-search').on 'change', (e) ->
            $location.path("/neighborhood/#{this.value}/crime");
            $scope.$apply();
      }
  ]
)