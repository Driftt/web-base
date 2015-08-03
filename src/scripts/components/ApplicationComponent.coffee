DocumentTitle = require('react-document-title')
DocMeta = require('react-doc-meta')
RouteHandler = require('react-router').RouteHandler
APP_TITLE = require('constants/ResourcesConstants').APP_TITLE
component = React.createElement
SERVER_SIDE_STYLE_ID = require('constants/ResourcesConstants').SERVER_SIDE_STYLE_ID

ApplicationComponent = React.createClass({
  componentDidMount: ->
    # remove server side style
    serverSideStyle = document.getElementById(SERVER_SIDE_STYLE_ID)
    if(serverSideStyle)
      document.getElementsByTagName('head')[0].removeChild(serverSideStyle)

  getMetaTags: ->
    [
      { name: 'viewport', content: 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' }
    ]

  render: ->
    component DocMeta, { tags: @getMetaTags() },
      component DocumentTitle, { title: APP_TITLE },
        component RouteHandler, React.__spread({}, @props)
})

module.exports = ApplicationComponent
