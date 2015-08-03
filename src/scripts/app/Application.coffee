# From Marty documentation
# (http://martyjs.org/guides/application/automatic-registration.html)

# "It's easy to forget to register a type in the application after you create
# it. Fortunately if you're using webpack or browserify we can automate the
# registration process."

context = require.context('../', true, /^\.\/(actions|queries|sources|stores)/)

Application = Marty.createApplication ->
  _.each context.keys(), (key) =>
    if not /\.coffee/.test(key)
      id = key.replace('./', '').replace(/\//g, '.')
      @register(id, context(key))

module.exports = Application
