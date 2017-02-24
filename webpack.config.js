module.exports = {
  devtool: 'eval',
  context: __dirname + "/app/js",

  entry: "./app.js",

  output: {
    filename: "app_bundle.js",
    path:__dirname + '/app/assets/javascripts'
  },
  resolve: {
    extensions: ['.webpack.js', '.web.js', '.js', '.jsx']
  },

  module: {
    // Load the react-hot-loader
    loaders: [
      { 
        test: /\.js$/, 
        exclude: /node_modules/,
        loaders: ['babel-loader?presets[]=es2015&presets[]=react'] 
      }
    ]
  }
};
