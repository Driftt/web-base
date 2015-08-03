GithubConstants = require('constants/GithubConstants')

GithubStore = Marty.createStore({
  id: 'GithubStore'

  getInitialState: ->
    {
      stargazersByRepoID: {}
    }

  handlers: {
    fetchStargazersDone: GithubConstants.STARGAZERS_FETCH_DONE
    getOrFetchStargazers: GithubConstants.STARGAZERS_FETCH
    fetchStargazersFailed: GithubConstants.STARGAZERS_FETCH_FAILED
  }

  fetchStargazersDone: (repoOwner, repoName, stargazers) ->
    debugger
    repoId = "#{ repoOwner }/#{ repoName }"
    stargazersByRepoID = _.cloneDeep(@state.stargazersByRepoID)
    stargazersByRepoID[repoId] = stargazers
    @setState({ stargazersByRepoID: stargazersByRepoID })

  fetchStargazersFailed: (repoOwner, repoName) ->
    repoId = "#{ repoOwner }/#{ repoName }"
    stargazersByRepoID = _.cloneDeep(@state.stargazersByRepoID)
    stargazersByRepoID[repoId] = null
    @setState({ stargazersByRepoID: stargazersByRepoID })

  getOrFetchStargazers: (repoOwner, repoName) ->
    repoId = "#{ repoOwner }/#{ repoName }"
    @fetch({
      id: "getStarGazers#{ repoId }"
      locally: ->
        @state.stargazersByRepoID[repoId]
      remotely: ->
        @app.queries.GithubQueries.fetchRepoStargazers(repoOwner, repoName)
    })

  getStargazers: ->
    return @state.stargazersByRepoID
})

module.exports = GithubStore

