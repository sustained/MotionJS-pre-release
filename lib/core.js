define(['natives/math', 'natives/array', 'natives/number', 'natives/string'], function() {
  var Motion, isBrowser, method, root, toString, _i, _len, _ref, _ref2;
  toString = Object.prototype.toString;
  isBrowser = (typeof window != "undefined" && window !== null) && (typeof document != "undefined" && document !== null) && (typeof navigator != "undefined" && navigator !== null);
  root = isBrowser ? window : global;
  if (root.Motion != null) {
    return root.Motion;
  }
  Motion = root.Motion = {
    env: isBrowser ? 'client' : 'server',
    root: root,
    globalize: function() {
      var i, _i, _len, _ref;
      _ref = ['ext', 'extend', 'inc', 'include'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        root[i] = Motion[i];
      }
      return true;
    },
    version: '0.1'
  };
  root.isString = function(obj) {
    return toString.call(obj) === '[object String]';
  };
  root.isObject = function(obj) {
    return toString.call(obj) === '[object Object]';
  };
  root.isNumber = function(obj) {
    return toString.call(obj) === '[object Number]';
  };
  root.isRegExp = function(obj) {
    return toString.call(obj) === '[object RegExp]';
  };
  root.isFunction = function(obj) {
    return toString.call(obj) === '[object Function]';
  };
  root.isArray = (_ref = Array.isArray) != null ? _ref : function(obj) {
    return toString.call(obj) === '[object Array]';
  };
  root.isInfinite = function(obj) {
    return !isFinite(obj);
  };
  Motion.ext = Motion.extend = function(object, mixin, overwrite) {
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
  Motion.inc = Motion.include = function(klass, mixin) {
    return Motion.ext(klass.prototype, mixin);
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