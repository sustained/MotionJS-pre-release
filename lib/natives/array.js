var _ref, _ref2;
var __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
Array.prototype.sum = function() {
  var i, sum, _i, _len;
  sum = 0;
  for (_i = 0, _len = this.length; _i < _len; _i++) {
    i = this[_i];
    sum += i;
  }
  return sum;
};
Array.prototype.append = Array.prototype.push;
Array.prototype.prepend = Array.prototype.unshift;
Array.prototype.map = (_ref = Array.prototype.map) != null ? _ref : function() {};
Array.prototype.zip = function() {};
Array.prototype.unique = function() {
  var i, uniq, _i, _len, _ref;
  uniq = [];
  for (_i = 0, _len = this.length; _i < _len; _i++) {
    i = this[_i];
    if (_ref = !i, __indexOf.call(this, _ref) >= 0) {
      uniq.push(i);
    }
  }
  return uniq;
};
Array.prototype.each = (_ref2 = Array.prototype.forEach) != null ? _ref2 : function(func, bind) {
  var i, _i, _len, _results;
  if (bind == null) {
    bind = null;
  }
  _results = [];
  for (_i = 0, _len = this.length; _i < _len; _i++) {
    i = this[_i];
    _results.push(func.call(bind, i, _i, this));
  }
  return _results;
};
Array.prototype.empty = function() {
  return this.length === 0;
};
Array.prototype.first = function() {
  return this[0];
};
Array.prototype.random = function() {
  return this[Math.rand(this.length)];
};
Array.prototype.last = function() {
  return this[this.length - 1];
};
Array.prototype.count = function(obj) {
  var count, i, _i, _j, _len, _len2;
  count = 0;
  if (isFunction(obj)) {
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      i = this[_i];
      if (obj(i) === true) {
        count++;
      }
    }
  } else {
    for (_j = 0, _len2 = this.length; _j < _len2; _j++) {
      i = this[_j];
      if (obj === i) {
        count++;
      }
    }
  }
  return count;
};
Array.prototype.compact = function() {
  var compacted, i, _i, _len;
  compacted = [];
  for (_i = 0, _len = this.length; _i < _len; _i++) {
    i = this[_i];
    if (i != null) {
      compacted.push(i);
    }
  }
  return compacted;
};
Array.prototype.remove = function(remove) {
  var array, i, _i, _len;
  array = [];
  if (!isArray(remove)) {
    remove = [remove];
  }
  for (_i = 0, _len = this.length; _i < _len; _i++) {
    i = this[_i];
    if (__indexOf.call(remove, i) >= 0) {
      continue;
    }
    array.push(i);
  }
  return array;
};