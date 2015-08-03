var allStuff = []
exports.collect = function(fn) {
  var stuff = [];
  function add(css) {
    stuff.push(css);
  }
  var old = exports.add;
  exports.add = add;
  fn();
  exports.add = old;
  return stuff.join("\n");
}

exports.getStyles = function() {
  return allStuff.join("\n");
}

exports.add = function(a) {
  allStuff.push(a[0][1])
}