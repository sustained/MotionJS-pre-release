define(function() {
  Number.prototype.abs = function() {
    return Math.abs(this);
  };
  Number.prototype.chr = function() {
    return String.fromCharCode(this);
  };
  Number.prototype.odd = function() {
    return this & 1;
  };
  Number.prototype.even = function() {
    return !this & 1;
  };
  Number.prototype.ceil = function() {
    return Math.ceil(this);
  };
  Number.prototype.floor = function() {
    return Math.floor(this);
  };
  Number.prototype.round = function() {
    return Math.round(this);
  };
  Number.prototype.times = function(iter) {
    var i, n, _results;
    i = 0;
    n = this.abs();
    _results = [];
    while (i < n) {
      _results.push(iter(i++));
    }
    return _results;
  };
  Number.prototype.upto = function(to, iter) {
    var index, item, _results;
    if (to < this) {
      return false;
    }
    item = this;
    index = to - this;
    _results = [];
    while (index--) {
      _results.push(iter(item++));
    }
    return _results;
  };
  Number.prototype.downto = function(to, iter) {
    var index, item, _results;
    if (to > this) {
      return false;
    }
    item = this;
    index = this - to;
    _results = [];
    while (index--) {
      _results.push(iter(item--));
    }
    return _results;
  };
  Number.prototype.random = function() {
    return (rand * this).round();
  };
  return true;
});