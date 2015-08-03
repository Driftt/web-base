if __ENV__ is 'PRODUCTION'
  # set production variables the app needs here
  ResourcesConstants = {}
#dev
else
  ResourcesConstants = {}

ResourcesConstants.DRIFFT_HOME_PAGE = 'https://www.driftt.com'
ResourcesConstants.APP_TITLE = 'Driftt Marty Base'
ResourcesConstants.SERVER_SIDE_STYLE_ID = 'server-side-style'
ResourcesConstants.REACT_CONTENT_ID = 'react-content'

module.exports = ResourcesConstants
