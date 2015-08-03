gulp = require('gulp')
gulpWebpack = require('gulp-webpack')
gutil = require('gulp-util')
plugins = require('gulp-load-plugins')()
runSequence = require('run-sequence')
coffeelint = require('gulp-coffeelint')
serverConfig = require('./config/server.config')
exec = require('child_process').exec

WebpackDevServer = require('webpack-dev-server')
makeHotDevWebPackConfig = require('./WebPackConfigCreator').makeHotDevWebPackConfig
makeServerSideWebPackConfig = require('./WebPackConfigCreator').makeServerSideWebPackConfig
makeClientSideWebPackConfig = require('./WebPackConfigCreator').makeClientSideWebPackConfig
webpack = require('webpack')

ENV = process.env.NODE_ENV || 'DEV'

{ config } = require('rygr-util')
config.initialize('config/*.json')

# removes all server deployment assets
gulp.task 'clean', ->
  gulp.src("#{ serverConfig.deployDir }assets/*", { read: false }).pipe plugins.clean()

# there is an additional lint in the webpack
# this is for files not packed (like this gulpfile)
gulp.task 'coffeelint', ->
  gulp.src('./*.coffee')
    .pipe(coffeelint('config/coffeelintrc.json'))
    .pipe(coffeelint.reporter())

# implicitly renders the client js and serves it via a hot reloader
gulp.task 'webpack-hot-reload-server', (cb) ->
  webpackConfig = makeHotDevWebPackConfig()
  compiler = webpack(webpackConfig)
  DEV_PORT = config.server.port
  # Start a webpack-hot-reload-server
  new WebpackDevServer(compiler, {
    hot: true,
    publicPath: '/assets/',
    historyApiFallback: true,
    stats: { colors: true },
    contentBase: './src/',
  }).listen DEV_PORT, 'localhost', (err) ->
    if err
      throw new (gutil.PluginError)('webpack-hot-reload-server', err)
    plugins.util.log("🎺  🎺  🎺  🎺    Webpack server started    🎷  🎷  🎷  🎷")
    plugins.util.log("🎬  🎬  🎬  🎬    Compiling client bundle   🎬  🎬  🎬  🎬")
  cb()

# Runs a hot reloaded express server with server-side rendering
gulp.task 'webpack-dev-server', (cb) ->
  webpackConfig = makeServerSideWebPackConfig('DEV', true)
  webpack webpackConfig, (err, stats) ->
    if err
      throw new (gutil.PluginError)('webpack:build', err)
  cb()

# Starts the express server created by the 'webpack-dev-server' task
gulp.task('node-server', (cb) ->
  exec("env NODE_ENV=#{ENV} node deploy/index.js", (err, stdout, stderr) ->
    plugins.util.log(stdout)
    plugins.util.log(stderr)
    cb(err)
  )
)

# Creates production bundles, one for server (render.js) one for client (main.js)
gulp.task 'build-bundles', (cb) ->
  config = [makeServerSideWebPackConfig(ENV), makeClientSideWebPackConfig(ENV)]
  webpack config, (err, stats) ->
    if err
      throw new (gutil.PluginError)('webpack:build', err)
    gutil.log('[webpack:build]', stats.toString({ colors: true }))
    cb()


# ------------------------------------------------------------------------------
# Sequences
# ------------------------------------------------------------------------------

gulp.task 'dev', (cb) ->
  runSequence('clean', ['webpack-dev-server', 'webpack-hot-reload-server', 'node-server'], cb)

# ------------------------------------------------------------------------------
# Default
# ------------------------------------------------------------------------------
#
gulp.task 'default', ->
  runSequence('dev')
