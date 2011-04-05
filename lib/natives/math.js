var __slice = Array.prototype.slice;
define(function() {
  Math.C = 299792458.0;
  Math.G = 6.6742e-11;
  Math.K = 0.5522848;
  Math.HALFPI = Math.PI * 0.5;
  Math.TAU = Math.TWOPI = Math.PI * 2;
  Math.rand = function(min, max) {
    var _ref, _ref2;
    if (!(max != null)) {
      if (!(min != null)) {
        return Math.random();
      }
      _ref = [0, min], min = _ref[0], max = _ref[1];
    }
    if (min > max) {
      _ref2 = [max, min], min = _ref2[0], max = _ref2[1];
    }
    return ((Math.random() * (max - min)) + min).round();
  };
  Math.nearest = function() {
    var dif, i, low, n, ret, set, _i, _len;
    n = arguments[0], set = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    ret = n;
    low = dif = null;
    for (_i = 0, _len = set.length; _i < _len; _i++) {
      i = set[_i];
      if (isNaN(i)) {
        continue;
      }
      dif = Math.abs(Math.max(i, n)) - Math.abs(Math.min(i, n));
      if (low === null || dif < low) {
        low = dif;
        ret = i;
      }
    }
    return ret;
  };
  Math.deg = Math.degrees = function(radians) {
    return radians * (180 / Math.PI);
  };
  Math.rad = Math.radians = function(degrees) {
    return degrees * (Math.PI / 180);
  };
  Math.sq = function(n) {
    return n * n;
  };
  Math.lerp = function(a, b, t) {
    return ((b - a) * t) + a;
  };
  Math.norm = function(n, range) {
    if (isVector(range)) {
      range = range.array();
    }
    return (n - range[0]) / (range[1] - range[0]);
  };
  Math.wrap = function(n, min, max) {
    if (n < min) {
      return (n - min) + max;
    }
    if (n > max) {
      return (n - max) + min;
    }
    return n;
  };
  Math.clamp = function(n, min, max) {
    if (n < min) {
      return min;
    }
    if (n > max) {
      return max;
    }
    return n;
  };
  Math.remap = function(n, current, target) {
    if (isVector(current)) {
      current = current.array();
    }
    if (isVector(target)) {
      target = target.array();
    }
    return (target[0] + (target[1] - target[0])) * ((n - current[0]) / (current[1] - current[0]));
  };
  return true;
});