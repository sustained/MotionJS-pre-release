require(['motion'], function(Motion) {
  var hash;
  hash = new Motion.Hash;
  hash.set('foo', 1);
  hash.set('bar', 2);
  hash.set('baz', 3);
  return puts(inspect(hash, true, 2));
});