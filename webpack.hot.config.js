var { resolve } = require('path');
var webpack = require('webpack');
var reactLoader = require('react-hot-loader');

module.exports = {
  devtool: 'eval',
  context: __dirname + "/app/js",

  entry: [
    'react-hot-loader/patch',
    'webpack-dev-server/client?http://localhost:9000',
    'webpack/hot/only-dev-server',
    './app.js'
  ],

  output: {
    filename: "app_bundle.js",
    path: __dirname + '/tmp/assets/js',
    pathinfo: true,
    publicPath: 'http://localhost:9000/assets/'
  },
  resolve: {
    extensions: ['.webpack.js', '.web.js', '.js', '.jsx']
  },
  devServer: {
    hot: true,
    publicPath: '/assets/',
    host: 'localhost',
    port: 9000,
    contentBase: resolve(__dirname, 'tmp/js'),
    headers: {
      'Access-Control-Allow-Origin': 'http://localhost:3000',
      'Access-Control-Allow-Credentials': 'true'
    }
  },

  // Require the webpack and react-hot-loader plugins
  plugins: [  
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.NamedModulesPlugin()
  ],

  module: {
    // Load the react-hot-loader
    rules: [
      { 
        test: /^((?!(.hot-update)).)*\.js$/, 
        exclude: /node_modules/,
        loaders: ['babel-loader?presets[]=es2015&presets[]=react'] 
      }
    ]
  }
};
