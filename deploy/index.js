var app, compression, cookieParser, express, morgan, page, path, piping, server, stats, useragent;

express = require('express');
path = require('path');
morgan = require('morgan');
compression = require('compression');
useragent = require('express-useragent');
cookieParser = require('cookie-parser');

if (process.env.NODE_ENV == 'DEV') {
  piping = require('piping')({
    hook: true
  });
  if (!piping) {
    return;
  }
}

if (process.env.NODE_ENV == 'DEV') {
  runTimeScriptName = 'http://localhost:8080/assets/main.js'
} else {
  stats = require('./webpack-assets.json');
  runTimeScriptName = stats.main;
}

page = require('./assets/render.js');
app = express();
app.use(compression());
app.use(useragent.express());
app.use(cookieParser());
app.use(morgan('combined'));
app.use('/assets', express["static"](path.join(__dirname, 'assets')));

app.get('/*', function(req, res) {
  res.header("Content-Type", "text/html");
  return page(req, res, runTimeScriptName);
});

server = app.listen(8003, function() {
  console.log('Listening on port %d', server.address().port);
});
