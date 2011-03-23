define(['math/vector', 'math/matrix', 'math/random', 'natives/hash', 'natives/math', 'natives/array', 'natives/number', 'natives/string'], function(Vector, Matrix, Random) {
  var Motion, ext, inc, isBrowser, method, root, toString, _i, _len, _ref, _ref2;
  toString = Object.prototype.toString;
  isBrowser = (typeof window != "undefined" && window !== null) && (typeof document != "undefined" && document !== null) && (typeof navigator != "undefined" && navigator !== null);
  root = isBrowser ? window : global;
  if (root.Motion != null) {
    return root.Motion;
  }
  Motion = root.$M = root.Motion = {
    env: isBrowser ? 'client' : 'server',
    root: root,
    version: '0.1'
  };
  Math.Vector = Vector;
  Math.Matrix = Matrix;
  Math.Random = Random;
  ext = Motion.extend = function(object, mixin, overwrite) {
    var k, v;
    if (overwrite == null) {
      overwrite = true;
    }
    for (k in mixin) {
      v = mixin[k];
      if (overwrite === false && k in object) {
        continue;
      }
      object[k] = v;
    }
    return object;
  };
  inc = Motion.include = function(klass, mixin) {
    return Motion.extend(klass.prototype, mixin);
  };
  Motion.setup = function(opts) {
    return opts = ext({}, opts);
  };
  root.isA = function(object, klass) {
    return (object != null) && object instanceof klass;
  };
  root.isArray = (_ref = Array.isArray) != null ? _ref : function(obj) {
    return toString.call(obj) === '[object Array]';
  };
  root.isString = function(object) {
    return toString.call(object) === '[object String]';
  };
  root.isObject = function(object) {
    return toString.call(object) === '[object Object]';
  };
  root.isNumber = function(object) {
    return toString.call(object) === '[object Number]';
  };
  root.isRegExp = function(object) {
    return toString.call(object) === '[object RegExp]';
  };
  root.isFunction = function(object) {
    return toString.call(object) === '[object Function]';
  };
  root.isInfinite = function(object) {
    return !isFinite(object);
  };
  root.isVector = function(object) {
    return isA(object, Math.Vector);
  };
  root.isMatrix = function(object) {
    return isA(object, Math.Matrix);
  };
  if (!(root.console != null)) {
    root.console = {};
    _ref2 = 'assert count debug dir dirxml\nerror group groupCollapsed groupEnd\ninfo log markTimeline profile\nprofileEnd time timeEnd trace warn'.split(/\s+/);
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      method = _ref2[_i];
      root.console[method] = function() {
        return null;
      };
    }
  }
  return Motion;
});