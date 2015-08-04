# web-marty-universal-base
****************************************

Driftt's universal web application base built on the following technologies

- [Marty (Flux implementation with client side state hydration)]()
- Isomorphic/Universal rendering
- [React](http://facebook.github.io/react/)
- [React Router](https://github.com/rackt/react-router)
- [Express](http://expressjs.com/)
- [Coffeescript (for development speed & NO JSX)](http://coffeescript.org/)
- [Webpack for bundling](http://webpack.github.io/)
- [Webpack Dev Server (serves hot updates)](http://webpack.github.io/docs/webpack-dev-server.html)
- [Stylus with Nib](https://learnboost.github.io/stylus/)


Installation
============

Install packages and gulp-cli (if not installed):

    $ npm install
    $ npm install --global gulp


Development Build and Server with Hot Reload
============

This setup runs a hot reloaded express server serving server-side rendered pages in addition to a web-pack development server which hot-swaps code with the client as you code.

    $ gulp
    go to http://localhost:8003/ for real time hot reload


Creating a New Page Component
============

 * create a react component under src/scripts/components for the new page see [Viewer](https://github.com/Driftt/web-marty-universal-base/blob/master/src/scripts/components/Viewer.coffee) on how to create a component
 * implement a new react route for the component in src/scripts/routes.coffee

 ```
    NewPage = require('components/NewPage')
    ...
    component Route, {
      name: 'newPage'
      path: 'newPage'
      handler: createAsyncHandler(NewPage)
    }
```

 * give yourself a good [pat on the back](http://idioms.thefreedictionary.com/pat+on+the+back)


No Templating Language
=====================

We weren't crazy about using yet another templating language so we decided to just keep our components 100% coffeescript. And because they are coffeescript they have the simplicity and cleanliness of jade with the expressiveness of javascript. Here is an example:

ES6 & JSX:

```
render() {
  names = ['Marshall', 'Sitian', 'Alden', 'Elyse', 'Richard', 'Katie']

  return (
    <div>
      <h1>This is a header</h1>
      <p>A paragraph</p>
      <div className='names'>
        {
          names.map((name) =>
            <User name=name/>
          )
        }
      </div>
    </div>
  );
}
```

Our Coffeescript solution:

```
dom = React.DOM
component = React.createElement

render: ->
  names = ['Marshall', 'Sitian', 'Alden', 'Elyse', 'Richard', 'Katie']

  dom.div {}
    dom.h1 {}, 'This is a header'
    dom.p {}, 'A paragraph'
    dom.div { className: 'names' },
      _.map names, (name) ->
        component User, { name: name }
```
