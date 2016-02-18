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
  '$locationProvider'
  '$urlRouterProvider',
  ($httpProvider, $stateProvider, $locationProvider, $urlRouterProvider)->
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

    $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise('/')
])
