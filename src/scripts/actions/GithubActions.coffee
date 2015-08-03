GithubConstants = require('constants/GithubConstants')

GithubActions = Marty.createActionCreators({
  fetchStargazers: (repoOwner, repoName) ->
    @dispatch(GithubConstants.STARGAZERS_FETCH, repoOwner, repoName)
})

module.exports = GithubActions
