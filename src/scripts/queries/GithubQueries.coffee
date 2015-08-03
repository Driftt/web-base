GithubConstants = require('constants/GithubConstants')

GithubQueries = Marty.createQueries({
  id: 'GithubQueries'

  fetchRepoStargazers: (repoOwner, repoName) ->
    stargazersPromise = @app.sources.GithubAPI.fetchRepoStargazers(repoOwner, repoName)

    stargazersPromise.then (res) =>
      if res.status is 200
        @dispatch(GithubConstants.STARGAZERS_FETCH_DONE, repoOwner, repoName, res.body)
      else
        @dispatch(GithubConstants.STARGAZERS_FETCH_FAILED, repoOwner, repoName, res.error)

    stargazersPromise.catch (error) =>
      @dispatch(GithubConstants.STARGAZERS_FETCH_FAILED, repoOwner, repoName, error)
})

module.exports = GithubQueries
