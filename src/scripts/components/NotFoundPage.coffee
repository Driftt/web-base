dom = React.DOM

NotFoundPage = React.createClass({
  render: ->
    dom.h1 {}, 'Sorry, that page doesn\'t exist'
})

module.exports = NotFoundPage