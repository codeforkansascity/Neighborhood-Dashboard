@app = angular.module('neighborhoodstat',
  [
    'templates',
    'ngRoute',
    'ngResource',
    'ui.router',
    'ngAnimate'
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
      .state('neighborhood.crime'
        url: '/crime',
        templateUrl: 'crime.html',
        controller: 'CrimeCtrl'
      )
      .state('neighborhood.vacancies',
        url: '/vacancies',
        templateUrl: 'vacancies.html',
        controller: 'VacanciesCtrl'
      )

    $urlRouterProvider.otherwise('/')
])
