var webpack = require('webpack');
var reactLoader = require('react-hot-loader')

module.exports = {
  context: __dirname,

  entry: {
    App: [
      'webpack-dev-server/client?http://localhost:8080/assets/',
      'webpack/hot/only-dev-server',
      './app/js/app.js'
    ]
  },

  output: {
    filename: 'bundle.js', // Will output bundle.js
    path: __dirname + '/app/assets/javascripts', // Save to Rails Asset Pipeline
    publicPath: 'http://localhost:8080/assets' // Required for webpack-dev-server
  },
  
  // Require the webpack and react-hot-loader plugins
  plugins: [  
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin()
  ],

  resolve: {
    extensions: ['.js', '.jsx']
  },

  module: {
    // Load the react-hot-loader
    loaders: [ { test: /\.jsx?$/, loaders: ['jsx-loader', 'react-hot-loader'] } ]
  }
}
