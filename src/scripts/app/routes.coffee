Router = require('react-router')
Route = Router.Route
DefaultRoute = Router.DefaultRoute
NotFoundRoute = Router.NotFoundRoute
Redirect = Router.Redirect
component = React.createElement

ApplicationComponent = require('components/ApplicationComponent')

HomePageRedirect = require('components/HomePageRedirect')
GithubStargazers = require('components/GithubStargazers')
NotFoundPage = require('components/NotFoundPage')

Routes =
  component Route, { name: 'app', path: '/', handler: ApplicationComponent },

    component Route, { path: '/toDriftt', handler: HomePageRedirect }

    component Route, {
      name: 'stargazers'
      path: 'stargazers'
      handler: GithubStargazers
    }

    component DefaultRoute, { handler: GithubStargazers }
    component NotFoundRoute, { handler: NotFoundPage }

module.exports = Routes
