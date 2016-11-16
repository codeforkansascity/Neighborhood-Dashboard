angular.module('neighborhoodstat').directive('neighborhoodSearch',
  [
    '$location',
    ($location) ->
      return {
        templateUrl: 'neighborhood_search.html',
        link: ($scope, element, attrs)->
          $('#neighborhood-search').select2(
            {
              minimumInputLength: 1,
              allowClear: true,
              width: '15em',
              placeholder: 'Search for Neighborhood',
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
            $('body').removeClass('modal-open')
            $('.modal-backdrop').remove()
            $location.path("/neighborhood/#{this.value}/crime");
            $scope.$apply();
      }
  ]
)
