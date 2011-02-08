define(['classutils'], function(ClassUtils) {
  var Vector;
  Vector = (function() {
    function Vector(i, j) {
      this.set(i, j);
    }
    Vector.equal = function(a, b) {
      return a.i === b.i && a.j === b.j;
    };
    Vector.equals = Vector.equal;
    Vector.add = function(a, b) {
      return new this(a.i + b.i, a.j + b.j);
    };
    Vector.subtract = function(a, b) {
      return new this(a.i - b.i, a.j - b.j);
    };
    Vector.multiply = function(v, n) {
      return new this(v.i * n, v.j * n);
    };
    Vector.divide = function(v, n) {
      return new this(v.i / n, v.j / n);
    };
    Vector.perpendicular = function(v) {
      return new this(-v.j, v.i);
    };
    Vector.limit = function(v, n) {
      var vec;
      vec = v.clone();
      if (vec.length() > n) {
        return vec.normalize().multiply(n);
      } else {
        return vec;
      }
    };
    Vector.normalize = function(v) {
      var len, vec;
      vec = v.clone();
      len = v.length();
      if (len === 0) {
        return vec;
      } else {
        return vec.divide(len);
      }
    };
    Vector.invert = function(v) {
      return new this(-v.i, -v.j);
    };
    Vector.distance = function(a, b) {
      return a.clone().subtract(b).length();
    };
    Vector.floor = function(v) {
      return v.clone().floor();
    };
    Vector.round = function(v) {
      return v.clone().round();
    };
    Vector.ceil = function(v) {
      return v.clone().ceil();
    };
    Vector.rotate = function(v, theta) {
      return v.clone().rotate(theta);
    };
    Vector.projectPoint = function(point) {};
    Vector.prototype.set = function(i, j) {
      this.i = i != null ? i : 0;
      this.j = j != null ? j : 0;
      return this;
    };
    Vector.prototype.copy = function(v) {
      return this.set(v.i, v.j);
    };
    Vector.prototype.clone = function() {
      return new Vector(this.i, this.j);
    };
    Vector.prototype.debug = function() {
      return "<Vector : i=" + this.i + ", j=" + this.j + ">";
    };
    Vector.prototype.toString = Vector.prototype.debug;
    Vector.prototype.equals = function(v) {
      return Vector.equals(this, v);
    };
    Vector.prototype.equal = Vector.prototype.equals;
    Vector.prototype.add = function(v) {
      this.i += v.i;
      this.j += v.j;
      return this;
    };
    Vector.prototype.subtract = function(v) {
      this.i -= v.i;
      this.j -= v.j;
      return this;
    };
    Vector.prototype.multiply = function(n) {
      this.i *= n;
      this.j *= n;
      return this;
    };
    Vector.prototype.divide = function(n) {
      this.i /= n;
      this.j /= n;
      return this;
    };
    Vector.prototype.transform = function(matrix) {
      return this.clone().set(this.i * matrix.a + this.j * matrix.c + matrix.tx, this.i * matrix.b + this.j * matrix.d + matrix.ty);
    };
    Vector.prototype.dot = function(v) {
      return (this.i * v.i) + (this.j * v.j);
    };
    Vector.prototype.perpDot = function(v) {
      return (this.i * v.j) + (-this.j * v.i);
    };
    Vector.prototype.cross = function(v) {
      return (this.i * v.j) - (this.j * v.i);
    };
    Vector.prototype.length = function() {
      return Math.sqrt(this.dot(this));
    };
    Vector.prototype.lengthSquared = function() {
      return this.dot(this);
    };
    Vector.prototype.magnitude = Vector.prototype.length;
    Vector.prototype.angle = function() {
      return Math.atan2(this.j, this.i);
    };
    Vector.prototype.distance = function(v) {
      return Math.sqrt(this.distanceSquared(v));
    };
    Vector.prototype.distanceSquared = function(v) {
      return v.clone().subtract(this).lengthSquared();
    };
    Vector.prototype.leftNormal = function() {
      return new Vector(this.j, -this.i);
    };
    Vector.prototype.rightNormal = function() {
      return new Vector(-this.j, this.i);
    };
    Vector.prototype.limit = function(n) {
      if (this.length() > n) {
        return this.normalize().multiply(n);
      } else {
        return this;
      }
    };
    Vector.prototype.rotate = function(theta) {
      this.i = (this.i * Math.cos(theta)) - (this.j * Math.sin(theta));
      this.j = (this.i * Math.sin(theta)) + (this.j * Math.cos(theta));
      return this;
    };
    Vector.prototype.round = function(n) {
      this.i = this.i.round();
      this.j = this.j.round();
      return this;
    };
    Vector.prototype.normalize = function() {
      var length;
      length = this.length();
      if (length === 0) {
        this.i = 1;
        return this;
      } else {
        return this.divide(length);
      }
    };
    Vector.prototype.truncate = function(max) {
      this.length = Math.min(max, this.length());
      return this;
    };
    Vector.prototype.invert = function() {
      return this.set(-this.i, -this.j);
    };
    Vector.prototype.isZero = function() {
      return this.i === 0 && this.j === 0;
    };
    Vector.prototype.isUnit = function() {
      return this.length() === 1;
    };
    Vector.prototype.isNormal = Vector.prototype.isUnit;
    Vector.prototype.draw = function(graphics) {
      graphics.beginPath();
      graphics.moveTo(0, 0);
      graphics.lineTo(this.i, this.j);
      return graphics.closePath();
    };
    return Vector;
  })();
  return Vector;
});