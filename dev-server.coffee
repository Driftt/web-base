webpack = require('webpack')
WebpackDevServer = require('webpack-dev-server')
gutil = require('gulp-util')
{ config } = require('rygr-util')
config.initialize('config/*.json')

makeHotDevWebPackConfig = require('./WebPackConfigCreator').makeHotDevWebPackConfig
webpackConfig = makeHotDevWebPackConfig()
compiler = webpack(webpackConfig)
DEV_PORT = config.server.port

# Start a webpack-dev-server
new WebpackDevServer(compiler, {
  hot: true,
  publicPath: '/assets/',
  historyApiFallback: true,
  stats: { colors: true },
  contentBase: './src/',
}).listen DEV_PORT, 'localhost', (err) ->
  if err
    throw new (gutil.PluginError)('webpack-dev-server', err)
