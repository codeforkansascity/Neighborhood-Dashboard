module.exports = {
  context: __dirname + "/app",

  entry: "./js/app.js",

  output: {
    filename: "bundle.js",
    path: __dirname + "/tmp/js/",
  },
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.js', '.jsx']
  }
};
