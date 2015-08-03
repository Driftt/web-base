styleCollector = require('./style-collector')
dom = React.DOM
DocumentTitle = require('react-document-title')
DocMeta = require('react-doc-meta')
SERVER_SIDE_STYLE_ID = require('constants/ResourcesConstants').SERVER_SIDE_STYLE_ID
REACT_CONTENT_ID = require('constants/ResourcesConstants').REACT_CONTENT_ID
require('styles/main.styl')

HTML = React.createClass({
  render: ->
    css = styleCollector.getStyles()
    title = DocumentTitle.rewind()
    metaTags = DocMeta.rewind()

    dom.html {},
      dom.head { },
        dom.title {}, title
        dom.link { rel: 'icon', type: 'image/png', href: require('images/favicon.png') }
        dom.meta { charSet : 'utf-8' }
        _.map metaTags, (tag, index) ->
          dom.meta React.__spread({ dataDocMeta: 'true', key: index }, tag)
        dom.style { id: SERVER_SIDE_STYLE_ID, dangerouslySetInnerHTML: { __html: css } }
      dom.body { className: @props.bodyClass },
        dom.div { id: REACT_CONTENT_ID, dangerouslySetInnerHTML: { __html: @props.htmlBody } }
        dom.div { dangerouslySetInnerHTML: { __html: @props.htmlState } }
        dom.script { async: true, defer: true, src: @props.scriptFilename }
})

module.exports = HTML