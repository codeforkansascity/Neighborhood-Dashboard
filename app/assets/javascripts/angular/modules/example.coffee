@exampleApp = angular
  .module('app.exampleModule', [])
  .run(->
    console.log 'example module running'
  )