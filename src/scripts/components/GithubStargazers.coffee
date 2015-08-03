dom = React.DOM
component = React.createElement

require('styles/components/GithubStargazers.styl')

GithubStargazers = React.createClass({

  getInitialState: ->
    {
      repoOwnerInput: ''
      repoNameInput: ''
    }

  handleRepoOwnerChange: (repoOwner) ->
    @setState({ repoOwnerInput: repoOwner })

  handleRepoNameChange: (repoName) ->
    @setState({ repoNameInput: repoName })

  handleFetchButtonPress: ->
    @props.app.actions.GithubActions.fetchStargazers(@state.repoOwnerInput, @state.repoNameInput)

  render: ->
    ownerValueLink = { value: @state.repoOwnerInput, requestChange: @handleRepoOwnerChange }
    repoValueLink = { value: @state.repoNameInput, requestChange: @handleRepoNameChange }

    dom.div { className: 'gazersContainer' },
      dom.div { className: 'inputs' },
        dom.input { type: 'text', placeholder: 'Owner Name', valueLink: ownerValueLink }
        dom.input { type: 'text', placeholder: 'Repo Name', valueLink: repoValueLink }
        dom.button { onClick: @handleFetchButtonPress }, 'Get Stargazers'
      dom.h1 {}, 'Gazers'
      _.map @props.gazersByRepo, (gazers) ->
        dom.div { className: 'stargazers' },
          _.map gazers, (gazer) ->
            dom.a { className: 'gazer', href: gazer.html_url },
              dom.div { className: 'name' }, gazer.login
              dom.img { src: gazer.avatar_url }
})

GithubStargazersContainer = Marty.createContainer(GithubStargazers, {
  listenTo: ['stores.GithubStore']

  fetch: {
    gazersByRepo: ->
      @app.stores.GithubStore.getStargazers()
  }

  failed: (errors) ->
    console.error(errors)
    dom.div {}, 'Error'
})

module.exports = GithubStargazersContainer
