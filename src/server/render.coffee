ReactRedirect = require('react-redirect')

dom = React.DOM
component = React.createElement

Application = require('app/Application')
CookiesHelper = require('utils/CookiesHelper')
makeRouter = require('server/ServerRouter').makeRouter
styleCollector = require('./style-collector')

HTML = require('server/HTML')
SERVER_SIDE_STYLE_ID = require('constants/ResourcesConstants').SERVER_SIDE_STYLE_ID
REACT_CONTENT_ID = require('constants/ResourcesConstants').REACT_CONTENT_ID

module.exports = (req, res, scriptFilename) ->
  CookiesHelper.setServerSideCookies(req.cookies)

  application = new Application()

  router = makeRouter(req, res)
  router.run (Handler, state) ->
    deepestRoute = state.routes[state.routes.length - 1]

    # @TODO only get the handler's style instead of the entire bundle

    componentHTMLPromise = application.renderToString(component Handler, {
      params: state.params
      app: application
    })

    componentHTMLPromise.then((result) ->
      redirect = ReactRedirect.rewind()
      if redirect
        res.redirect(302, redirect)
      else
        htmlResponse =
          React.renderToString(component HTML, {
            htmlBody: result.htmlBody
            # htmlState is the dehydrated state to allow the server to pass
            # state to the browser version.
            htmlState: result.htmlState
            bodyClass: deepestRoute.name
            scriptFilename: scriptFilename
          })

        res.end(htmlResponse)
    ).catch((e) ->
      console.error(e)
    )

