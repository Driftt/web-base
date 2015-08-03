webpack = require('webpack')
SaveAssetsJson = require('assets-webpack-plugin')
path = require('path')

serverConfig = require('./config/server.config')
makeBaseConfig = require('./config/WebpackBaseConfigMaker').makeBaseConfig

SERVER_SIDE_STYLE_LOADER = [{
  test: /\.styl/,
  loader: path.join(__dirname, 'src', 'server', 'style-collector') + '!css-loader!postcss-loader!stylus-loader'
}, {
  test: /\.css$/,
  loader: path.join(__dirname, 'src', 'server', 'style-collector') + '!css-loader!postcss-loader'
}]

CLIENT_SIDE_STYLE_LOADERS = [{
  test: /\.styl/,
  loader: 'style-loader!css-loader!postcss-loader!stylus-loader'
}, {
  test: /\.css$/,
  loader: 'style-loader!css-loader!postcss-loader'
}]

COFFEE_LOADER = { test: /\.coffee$/, loader: 'coffee' }
HOT_COFFEE_LOADER = { test: /\.coffee$/, loader: 'react-hot!coffee' }

setEnvRelatedConfigs = (config, ENV) ->
  # set up global env variable
  if ENV is 'PRODUCTION'
    NODE_ENV = '"production"'
    config.plugins = config.plugins.concat(new webpack.optimize.UglifyJsPlugin({ compress: { warnings: false } }))
  else
    NODE_ENV = '"development"'
  definePlugin = new webpack.DefinePlugin({
    __ENV__: JSON.stringify(ENV),
    'process.env': {
    # This has effect on the react lib size
      'NODE_ENV': NODE_ENV
    }
  })
  config.plugins = config.plugins.concat(definePlugin)
  config

makeHotDevWebPackConfig = ->
  baseConfig = makeBaseConfig()
  baseConfig = setEnvRelatedConfigs(baseConfig, 'DEV')
  baseConfig.output.filename = 'main.js'
  baseConfig.module.loaders = baseConfig.module.loaders.concat(CLIENT_SIDE_STYLE_LOADERS)
  baseConfig.plugins = baseConfig.plugins.concat(
    new (webpack.HotModuleReplacementPlugin),
    new (webpack.NoErrorsPlugin)
  )
  baseConfig.plugins = baseConfig.plugins.concat(
    new SaveAssetsJson({ path: serverConfig.deployDir })
  )
  baseConfig.devServer = {
    contentBase: "http://localhost:8003/",
    noInfo: true,
    hot: true,
    inline: true
  }
  baseConfig.plugins = baseConfig.plugins.concat(
    new SaveAssetsJson({ path: serverConfig.deployDir })
  )
  baseConfig.output.publicPath = 'http://localhost:8080/assets/'

  # extra entry point for development hotswap
  baseConfig.entry = ['./src/scripts/main.coffee', 'webpack/hot/only-dev-server', 'webpack-dev-server/client?http://localhost:8080',]
  baseConfig.module.loaders = baseConfig.module.loaders.concat(HOT_COFFEE_LOADER)

  baseConfig

makeServerSideWebPackConfig = (ENV, watch) ->
  baseConfig = makeBaseConfig()
  baseConfig = setEnvRelatedConfigs(baseConfig, ENV)
  baseConfig.watch = watch
  baseConfig.entry = './src/server/render.coffee'
  baseConfig.output.filename = 'render.js'

  unless ENV is 'PRODUCTION'
    baseConfig.output.publicPath = 'http://localhost:8080/assets/'

  baseConfig.target = 'node'
  baseConfig.output.libraryTarget = 'commonjs2'

  baseConfig.resolve.alias.server = serverConfig.serverScriptDir
  baseConfig.module.loaders = baseConfig.module.loaders.concat(COFFEE_LOADER)
  baseConfig.module.loaders = baseConfig.module.loaders.concat(SERVER_SIDE_STYLE_LOADER)
  baseConfig

makeClientSideWebPackConfig = (ENV) ->
  baseConfig = makeBaseConfig()
  baseConfig = setEnvRelatedConfigs(baseConfig, ENV)
  baseConfig.entry = './src/scripts/main.coffee'
  baseConfig.output.filename = 'main.[hash].js'
  baseConfig.module.loaders = baseConfig.module.loaders.concat(COFFEE_LOADER)
  baseConfig.module.loaders = baseConfig.module.loaders.concat(CLIENT_SIDE_STYLE_LOADERS)
  baseConfig.plugins = baseConfig.plugins.concat(
    new SaveAssetsJson({ path: serverConfig.deployDir })
  )
  baseConfig

module.exports = {
  makeHotDevWebPackConfig: makeHotDevWebPackConfig
  makeServerSideWebPackConfig: makeServerSideWebPackConfig
  makeClientSideWebPackConfig: makeClientSideWebPackConfig
}
