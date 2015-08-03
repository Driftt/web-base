GithubAPI = Marty.createStateSource({
  id: 'GithubAPI'
  type: 'http'
  baseUrl: 'https://api.github.com'

  fetchRepoStargazers: (repoOwner, repoName) ->
    @get({ url: "/repos/#{ repoOwner }/#{ repoName }/stargazers" })

})

module.exports = GithubAPI
