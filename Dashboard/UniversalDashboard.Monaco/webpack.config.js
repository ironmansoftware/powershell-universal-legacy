var webpack = require('webpack');
var path = require('path');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');

var BUILD_DIR = path.resolve(__dirname, 'public');
var SRC_DIR = path.resolve(__dirname);
var APP_DIR = path.resolve(__dirname, 'src/app');

module.exports = (env) => {
  const isDev = env == 'development' || env == 'isolated';

  return {
    entry: {
      'index' : __dirname + '/components/index.js'
    },
    output: {
      path: BUILD_DIR,
      filename: isDev ? 'monaco.[name].bundle.js' : '[name].[hash].bundle.js',
      sourceMapFilename: '[name].[hash].bundle.map',
      publicPath: "",
      library: 'udmonaco',
      libraryTarget: 'var'
    },
    module : {
      rules : [
        { test: /\.css$/, loader: "style-loader!css-loader" },
        { test: /\.(js|jsx)$/, exclude: [/node_modules/, /public/], loader: 'babel-loader'},
        { test: /\.(eot|ttf|woff2?|otf|svg|png)$/, loader:'file-loader', options: {
          name: '[name].[ext]'
        } }
      ]
    },
    externals: {
      UniversalDashboard: 'UniversalDashboard',
      $: "$",
      'react': 'react',
      'react-dom': 'reactdom'
    },
    resolve: {
      extensions: ['.json', '.js', '.jsx']
    },
    devtool: 'source-map',
    devServer: {
      disableHostCheck: true,
      historyApiFallback: true,
      port: 10000,
      // hot: true,
      compress:true,
      publicPath: '/',
      stats: "minimal"
    },
    plugins: [
      new MonacoWebpackPlugin()
    ]
  };
}

