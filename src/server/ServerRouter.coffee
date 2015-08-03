Router = require('react-router')
routes = require('app/routes')
encodeQueryData = require('utils/Helpers').encodeQueryData

makeRouter = (req, res) ->
  Router.create({
    onAbort: (options) ->
      queryString = encodeQueryData(options.query)
      destination = "/#{ options.to }#{ if queryString then "?#{ queryString }" else '' }"
      res.redirect(302, destination)
      console.log('Redirecting to:', destination)

    onError: (err) ->
      res.status(500).send('Opps')
      throw err
    routes: routes
    location: req.url
  })

module.exports = {
  makeRouter: makeRouter
}