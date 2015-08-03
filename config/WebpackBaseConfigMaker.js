'use strict';
var path = require("path")
var webpack = require('webpack')
var autoprefixer = require('autoprefixer-core')
var serverConfig = require('./server.config')

function makeBaseConfig() {
  return {

    output: {
      publicPath: '/assets/',
      path: serverConfig.deployDir + 'assets'
    },
    progress: true,
    cache: true,
    debug: true,
    devtool: "source-map",

    stats: {
      colors: true,
      reasons: true
    },
    coffeelint : { configFile: __dirname + '/coffeelintrc.json' },
    resolve: {
      extensions: ['', '.js', '.coffee'],
      root: serverConfig.scriptDir,
      alias: {
        'styles': serverConfig.stylesDir,
        'fonts' : serverConfig.fontsDir,
        'images': serverConfig.imageSDir,
        'bower_components': serverConfig.bowerDir
      }
    },
    module: {
      preLoaders: [{
        test: /\.coffee$/,
        exclude: /node_modules/,
        loader: "coffeelint-loader"
      }],
      loaders: [
        {
          test: /\.(jpe?g|png|gif|svg)$/i,
          loaders: [
            'file-loader?hash=sha512&digest=hex',
            'image-webpack-loader?{progressive:true, optimizationLevel: 1, interlaced: false, pngquant:{quality: "60-92", speed: 4}}'
          ]
        }, {
          test: /\.(otf|eot|ttf|woff)/,
          loader: 'url-loader?limit=8192'
        }, {
          test: /\.jsx/,
          loader: 'babel-loader?optional=es7.objectRestSpread'
        }
      ]
    },

    plugins: [
      new webpack.ProvidePlugin({
        React: 'react',
        Marty: 'marty',
        _: 'lodash'
      }),
      new webpack.IgnorePlugin(/vertx/),
      new webpack.optimize.OccurenceOrderPlugin(true),
    ],
    postcss: [autoprefixer]

  }
}

module.exports = {
  makeBaseConfig: makeBaseConfig
}