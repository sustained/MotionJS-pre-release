var __slice = Array.prototype.slice;
Math.C = 299792458.0;
Math.G = 6.6742e-11;
Math.K = 0.5522848;
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