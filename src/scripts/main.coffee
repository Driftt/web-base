require('whatwg-fetch')

component = React.createElement

Application = require('app/Application')
Router = require('react-router')
Routes = require('app/routes')

require('styles/main.styl')

application = new Application()
# Deserialize the dehydrated state and initialise the store.
# Used in conjunction with dehydrate for synchronising the state of a store on
# the server with its browser counterpart.
application.rehydrate()

# this enables Marty web developer tool
# https://chrome.google.com/webstore/detail/marty-developer-tools/fifcikknnbggajppebgolpkaambnkpae?hl=en
if __ENV__ is 'DEV'
  window.Marty = Marty

runApp = ->
  Router.run Routes, Router.HistoryLocation, (Handler, state) ->
    # decorate the body with the deepest route's name,
    # right only used for notFound, notAuthorized, internalError
    deepestRoute = state.routes[state.routes.length - 1]
    if deepestRoute
      document.body.className = deepestRoute.name

    params = state.params
    # render the router's matched Handler with application and params
    matchedComponent = component Handler, { params: params, app: application }
    React.render(matchedComponent, document.getElementById('react-content'))

# polyfill Promise if it is undefined
if not Promise?
  loadPromisePolyFill = require('bundle?lazy!es6-promise')
  loadPromisePolyFill((es6Promise) ->
    es6Promise.polyfill()
    runApp()
  )
else
  runApp()
