encodeQueryData = (data) ->
  ret = []
  for key, value of data
    ret.push(encodeURIComponent(key) + '=' + encodeURIComponent(value))
  ret.join('&')

module.exports = {
  encodeQueryData: encodeQueryData
}

