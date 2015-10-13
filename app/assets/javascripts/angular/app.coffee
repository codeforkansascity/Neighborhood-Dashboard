@app = angular.module('neighborhoodstat',
  [
    'templates',
    'ngRoute',
    'ngResource'
  ]
)

@app.config([
  '$httpProvider',
  '$routeProvider',
  '$locationProvider',
  ($httpProvider, $routeProvider, $locationProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

    $routeProvider
      .when('/',
        templateUrl: 'home.html'
        controller: 'NeighborhoodCtrl'
      )
      .when('/neighborhood/:neighborhoodId',
        templateUrl: 'neighborhood.html'
        controller: 'NeighborhoodCtrl'
      )
      .otherwise(
        redirectTo: '/'
      )
])

@app.run(->
)
