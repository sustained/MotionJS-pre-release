define(['classutils', 'math/vector'], function(ClassUtils, Vector) {
  var AABB;
  AABB = (function() {
    AABB.prototype.extents = null;
    AABB.prototype.t = 0;
    AABB.prototype.b = 0;
    AABB.prototype.l = 0;
    AABB.prototype.r = 0;
    AABB.prototype.h = 0;
    AABB.prototype.w = 0;
    AABB.prototype.hh = 0;
    AABB.prototype.hw = 0;
    AABB.prototype._isSquare = false;
    AABB.prototype.render = function(style) {
      return canvas.polygon([new Vector(this.position.i - this.l, this.position.j - this.t), new Vector(this.position.i + this.r, this.position.j - this.t), new Vector(this.position.i + this.r, this.position.j + this.b), new Vector(this.position.i - this.l, this.position.j + this.b)], style);
    };
    function AABB(position, extents) {
      if (position == null) {
        position = new Vector;
      }
      if (extents == null) {
        extents = {};
      }
      this.extents = {
        t: 0,
        b: 0,
        l: 0,
        r: 0
      };
      this.set(position, extents);
    }
    AABB.prototype.setTop = function(top) {
      return this.extents.t = top;
    };
    AABB.prototype.setBottom = function(bottom) {
      return this.extents.b = bottom;
    };
    AABB.prototype.setLeft = function(left) {
      return this.extents.l = left;
    };
    AABB.prototype.setRight = function(right) {
      return this.extents.r = right;
    };
    AABB.prototype.setExtents = function(extents) {
      if (extents == null) {
        extents = {};
      }
      if (isNumber(extents)) {
        extents = {
          t: extents,
          b: extents,
          l: extents,
          r: extents
        };
      }
      this.extents = Motion.extend(this.extents, extents);
      this.h = this.extents.t + this.extents.b;
      this.w = this.extents.l + this.extents.r;
      this._isSquare = this.h === this.w;
      this.hh = this.h / 2;
      return this.hw = this.w / 2;
    };
    AABB.prototype.setPosition = function(position) {
      this.position = position ? position.clone() : new Vector;
      this.t = this.position.j - this.extents.t;
      this.b = this.position.j + this.extents.b;
      this.l = this.position.i - this.extents.l;
      return this.r = this.position.i + this.extents.r;
    };
    AABB.prototype.set = function(position, extents) {
      this.setPosition(position);
      return this.setExtents(extents);
    };
    AABB.prototype.intersects = function(aabb) {
      var diff;
      diff = Vector.subtract(this.position, aabb.position).abs();
      return diff.j < this.hh + aabb.hh && diff.i < this.hw + aabb.hw;
    };
    AABB.prototype.contains = function(aabb) {
      return aabb.t > this.t && aabb.b < this.b && aabb.l > this.l && aabb.r < this.r;
    };
    AABB.prototype.containsPoint = function(v) {
      return v.j > this.t && v.j < this.b && v.i > this.l && v.i < this.r;
    };
    return AABB;
  })();
  return AABB;
});