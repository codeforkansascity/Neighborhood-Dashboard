@app = angular.module('neighborhoodstat',
  [
    'templates',
    'ngRoute',
    'ngResource',
    'ui.router'
  ]
)

@app.config([
  '$httpProvider',
  '$stateProvider',
  '$urlRouterProvider',
  ($httpProvider, $stateProvider, $urlRouterProvider)->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

    $stateProvider
      .state('home',
        url: '/'
        templateUrl: 'home.html'
        controller: 'NeighborhoodCtrl'
      )
      .state('neighborhood',
        url: '/neighborhood/:neighborhoodId'
        templateUrl: 'neighborhood.html'
        controller: 'NeighborhoodCtrl'
      )

    $urlRouterProvider.otherwise('/')
])

@app.run(->
)
