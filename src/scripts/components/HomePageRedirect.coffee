dom = React.DOM
component = React.createElement
ReactRedirect = require('react-redirect')
DRIFFT_HOME_PAGE = require('constants/ResourcesConstants').DRIFFT_HOME_PAGE

HomePageRedirect = React.createClass({
  render: ->
    component ReactRedirect, { location: DRIFFT_HOME_PAGE }
})

module.exports = HomePageRedirect
