var Hash;
Hash = (function() {
  Hash.prototype.length = 0;
  function Hash(keys, vals) {
    if (keys == null) {
      keys = {};
    }
    this._hash = {};
    if (isArray(keys) && isArray(vals)) {
      this.set(keys, vals);
    } else if (isObject(keys)) {
      this.set(keys);
    }
  }
  Hash.prototype.set = function(key, val) {
    var ind, k, max, v, _ref;
    if (isArray(key) && isArray(val) && key.length === val.length) {
      _ref = [0, key.length], ind = _ref[0], max = _ref[1];
      while (max > ind) {
        this.set(key[ind], val[ind]);
        ind++;
      }
      return this.length;
    } else if (isObject(key)) {
      for (k in key) {
        v = key[k];
        this.set(k, v);
      }
      return this.length;
    } else {
      this._hash[key] = val;
      return ++this.length;
    }
  };
  Hash.prototype.get = function(key, def) {
    if (def == null) {
      def = null;
    }
    if (key in this._hash) {
      return this._hash[key];
    }
    return def;
  };
  Hash.prototype.each = function(iter) {
    var k, v, _ref, _results;
    _ref = this._hash;
    _results = [];
    for (k in _ref) {
      v = _ref[k];
      _results.push(iter.call(null, k, v));
    }
    return _results;
  };
  Hash.prototype.eachKey = function(iter) {
    var k, _results;
    _results = [];
    for (k in this._hash) {
      _results.push(iter.call(null, k));
    }
    return _results;
  };
  Hash.prototype.eachVal = function(iter) {
    var k, v, _ref, _results;
    _ref = this._hash;
    _results = [];
    for (k in _ref) {
      v = _ref[k];
      _results.push(iter.call(null, v));
    }
    return _results;
  };
  Hash.prototype.keys = function() {
    return Object.keys(this._hash);
  };
  Hash.prototype.vals = function() {
    var k, v, _ref, _results;
    _ref = this._hash;
    _results = [];
    for (k in _ref) {
      v = _ref[k];
      _results.push(v);
    }
    return _results;
  };
  Hash.prototype.invert = function(self) {
    var hash;
    if (self == null) {
      self = false;
    }
    hash = new Hash(this.vals(), this.keys());
    if (self === true) {
      this._hash = hash._hash;
      this.length = hash.length;
      this;
    }
    return hash;
  };
  return Hash;
})();
define(function() {
  return Hash;
});