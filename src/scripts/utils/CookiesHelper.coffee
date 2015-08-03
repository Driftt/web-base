Cookies = require('cookies-js')

serverSideCookies = false

getCookie = (cookieName) ->
  if serverSideCookies
    accessToken = serverSideCookies[cookieName]
  else
    accessToken = Cookies.get(cookieName)
  accessToken

setServerSideCookies = (cookies) ->
  serverSideCookies = cookies

module.exports = {
  setServerSideCookies: setServerSideCookies
  getCookie: getCookie
}