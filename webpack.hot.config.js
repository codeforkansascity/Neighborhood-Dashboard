var { resolve } = require('path');
var webpack = require('webpack');
var reactLoader = require('react-hot-loader');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

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
    filename: "assets/javascripts/app_bundle.js",
    path: __dirname + '/app',
    pathinfo: true,
    publicPath: 'http://localhost:9000/'
  },
  resolve: {
    extensions: ['.webpack.js', '.web.js', '.js', '.jsx']
  },
  devServer: {
    hot: true,
    publicPath: '/assets/',
    host: 'localhost',
    port: 9000,
    contentBase: resolve(__dirname, 'app/assets/'),
    headers: {
      'Access-Control-Allow-Origin': 'http://localhost:3000',
      'Access-Control-Allow-Credentials': 'true'
    }
  },

  module: {
    // Load the react-hot-loader
    loaders: [
      { 
        test: /\.js$/, 
        exclude: /node_modules/,
        loaders: ['babel-loader?presets[]=es2015&presets[]=react'] 
      },
       // Extract css files
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader' })
      },
      // Optionally extract less files
      // or any other compile-to-css language
      {
        test: /\.less$/,
        loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader' })
      }
    ]
  },

  // Require the webpack and react-hot-loader plugins
  plugins: [
    new ExtractTextPlugin("assets/stylesheets/app_bundle.css"),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.NamedModulesPlugin()
  ]
};
