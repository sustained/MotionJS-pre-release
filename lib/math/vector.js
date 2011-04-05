define(function() {
  var Vector;
  Vector = (function() {
    function Vector(i, j) {
      if (isArray(i)) {
        this.set(i[0], i[1]);
      } else {
        this.set(i, j);
      }
    }
    Vector.Array = function(n, v) {
      var i, _results;
      if (v == null) {
        v = new this;
      }
      i = 0;
      _results = [];
      while (i < n) {
        _results.push(v);
      }
      return _results;
    };
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
    Vector.normalize = function(v) {
      var l;
      v = v.clone();
      l = v.length();
      if (l === 0) {
        return v.set(0.00000001, 0.00000001);
      } else {
        return v.divide(l);
      }
    };
    Vector.limit = function(v, n) {
      var l;
      v = v.clone();
      l = v.length();
      if (l > n) {
        return v.normalize().multiply(n);
      } else {
        return v;
      }
    };
    Vector.lerp = function(a, b, t) {
      return Vector.add(a, Vector.subtract(b, a).multiply(t));
    };
    Vector.invert = function(v) {
      return v.clone().invert();
    };
    Vector.angle = function() {
      var dot;
      return dot = this.dot;
    };
    Vector.rotate = function(v, theta) {
      return v.clone().rotate(theta);
    };
    Vector.abs = function(v) {
      return v.clone().abs();
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
    Vector.prototype.leftNormal = function(v) {
      return new this(v.j, -v.i);
    };
    Vector.prototype.rightNormal = function(v) {
      return new this(-v.j, v.i);
    };
    Vector.prototype.perpendicular = function(v) {
      return new this(-v.j, v.i);
    };
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
    Vector.prototype.normalize = function() {
      var l;
      l = this.length();
      if (l === 0) {
        return this;
      } else {
        return this.divide(l);
      }
    };
    Vector.prototype.limit = function(n) {
      if (this.length() > n) {
        return this.normalize().multiply(n);
      } else {
        return this;
      }
    };
    Vector.prototype.array = function() {
      return [this.i, this.j];
    };
    Vector.prototype.invert = function() {
      return this.set(-this.i, -this.j);
    };
    Vector.prototype.rotate = function(theta) {
      this.i = (this.i * Math.cos(theta)) - (this.j * Math.sin(theta));
      this.j = (this.i * Math.sin(theta)) + (this.j * Math.cos(theta));
      return this;
    };
    Vector.prototype.abs = function() {
      return this.set(Math.abs(this.i), Math.abs(this.j));
    };
    Vector.prototype.floor = function() {
      return this.set(Math.floor(this.i), Math.floor(this.j));
    };
    Vector.prototype.round = function() {
      return this.set(Math.round(this.i), Math.round(this.j));
    };
    Vector.prototype.ceil = function(v) {
      return this.set(Math.ceil(this.i), Math.ceil(this.j));
    };
    Vector.prototype.transform = function(matrix) {
      return this.clone().set(this.i * matrix.a + this.j * matrix.c + matrix.tx, this.i * matrix.b + this.j * matrix.d + matrix.ty);
    };
    Vector.prototype.leftNormal = function() {
      return new Vector(this.j, -this.i);
    };
    Vector.prototype.rightNormal = function() {
      return new Vector(-this.j, this.i);
    };
    Vector.prototype.length = function() {
      return Math.sqrt(this.dot(this));
    };
    Vector.prototype.lengthSquared = function() {
      return this.dot(this);
    };
    Vector.prototype.distance = function(v) {
      return Math.sqrt(this.distanceSquared(v));
    };
    Vector.prototype.distanceSquared = function(v) {
      return v.clone().subtract(this).lengthSquared();
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
    Vector.prototype.angle = function() {
      return Math.atan2(this.j, this.i);
    };
    Vector.prototype.sigh = function(v) {
      var dot, modA, modB;
      dot = this.dot(v);
      modA = this.length();
      modB = v.length();
      if (modA * modB === 0) {
        return null;
      }
      return Math.acos(Math.clamp(dot / (modA * modB), -1, 1));
    };
    /*
    		angleFrom: function(vector) {
    	    	var V = vector.elements || vector;
    	    	var n = this.elements.length, k = n, i;

    	    	if (n != V.length) { return null; }

    	    	var dot = 0, mod1 = 0, mod2 = 0;
    	    	// Work things out in parallel to save time
    	    	this.each(function(x, i) {
    	      		dot += x * V[i-1];
    	      		mod1 += x * x;
    	      		mod2 += V[i-1] * V[i-1];
    	    	});

    	    mod1 = Math.sqrt(mod1); mod2 = Math.sqrt(mod2);
    	    if (mod1*mod2 === 0) { return null; }

    	    var theta = dot / (mod1*mod2);
    	    if (theta < -1) { theta = -1; }
    	    if (theta > 1) { theta = 1; }

    	    return Math.acos(theta);
    	  },
    		*/
    Vector.prototype.realAngle = function(v) {
      var angle;
      angle = this.angle() - v.angle();
      return angle;
    };
    Vector.prototype.angleTo = function(v) {
      return this.angle() - v.angle();
    };
    Vector.prototype.angleFrom = function(v) {
      return v.angle() - this.angle();
    };
    Vector.prototype.equal = Vector.prototype.equals = function(v) {
      return Vector.equals(this, v);
    };
    Vector.prototype.isZero = function() {
      return this.i === 0 && this.j === 0;
    };
    Vector.prototype.isUnit = function() {
      return this.length() === 1;
    };
    Vector.prototype.isNormal = Vector.prototype.isUnit;
    /*

    		*/
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
    Vector.prototype.debug = Vector.prototype.toString = function() {
      return "Vector:(" + this.i + "," + this.j + ")";
    };
    return Vector;
  })();
  Vector.__defineGetter__('Zero', function() {
    return new Vector;
  });
  Vector.__defineGetter__('Rand', function() {
    return new Vector(Math.random() * Number.MAX_VALUE, Math.random() * Number.MAX_VALUE);
  });
  return Vector;
});