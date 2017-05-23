var ExtractTextPlugin = require('extract-text-webpack-plugin');
var ModernizrWebpackPlugin = require('modernizr-webpack-plugin');

var modernizrConfig = {
  'filename': 'js/modernizr-bundle.js',
  'feature-detects': [
    'inputtypes'
  ]
}

module.exports = {
  devtool: 'eval',
  context: __dirname + "/app/js",

  entry: "./app.jsx",

  output: {
    filename: "assets/javascripts/app_bundle.js",
    path:__dirname + '/app'
  },
  resolve: {
    extensions: ['.webpack.js', '.web.js', '.js', '.jsx']
  },

  module: {
    // Load the react-hot-loader
    loaders: [
      {
        test: /\.(js|jsx)$/,
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
      },
      {
        test: /\.(jpg|png|svg)$/,
        loader: 'url-loader'
      }
    ]
  },
  plugins: [
    new ModernizrWebpackPlugin(modernizrConfig),
    new ExtractTextPlugin("assets/stylesheets/app_bundle.css")
  ]
};
