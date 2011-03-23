var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['classutils', 'math/vector'], function(ClassUtils, Vector) {
  var AABB, NullAABB;
  NullAABB = {
    t: 0,
    r: 0,
    b: 0,
    l: 0
  };
  AABB = (function() {
    __extends(AABB, Polygon);
    AABB.prototype.w = 0;
    AABB.prototype.h = 0;
    AABB.prototype.hw = 0;
    AABB.prototype.hh = 0;
    AABB.prototype.extents = null;
    function AABB(position, extents) {
      if (extents == null) {
        extents = {};
      }
      this.extents = NullAABB;
      this.update(null, extents);
      AABB.__super__.constructor.call(this, [new Vector(-this.hw, -this.hh), new Vector(this.hw, -this.hh), new Vector(this.hw, this.hh), new Vector(-this.hw, this.hh)], position, [this.w, this.h]);
    }
    AABB.prototype.update = function(position, extents) {
      if (extents == null) {
        extents = {};
      }
      if (position != null) {
        this.position = position;
      }
      this.extents = Motion.extend(this.extents, extents);
      this.w = this.extents.l + this.extents.r;
      this.h = this.extents.t + this.extents.b;
      this.hw = this.w / 2;
      return this.hh = this.h / 2;
    };
    AABB.prototype.intersects = function(aabb) {
      var diff, sumX, sumY;
      sumX = this.hw + aabb.hw;
      sumY = this.hh + aabb.hh;
      diff = Vector.subtract(this.position, aabb.position).abs();
      return diff.i < sumX && diff.j < sumY;
    };
    AABB.prototype.contains = function(aabb) {
      return aabb.extents.t > this.extents.t && aabb.extents.b < this.extents.b && aabb.extents.l > this.extents.l && aabb.extents.r < this.extents.r;
    };
    AABB.prototype.containsPoint = function(v) {
      return v.j >= this.extents.t && v.j <= this.extents.b && v.i >= this.extents.l && v.i <= this.extents.r;
    };
    return AABB;
  })();
  return AABB;
});