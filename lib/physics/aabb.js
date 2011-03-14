define(['classutils', 'math/vector'], function(ClassUtils, Vector) {
  var AABB;
  AABB = (function() {
    AABB.prototype.t = 0;
    AABB.prototype.b = 0;
    AABB.prototype.l = 0;
    AABB.prototype.r = 0;
    function AABB(center, size) {
      if (center == null) {
        center = new Vector;
      }
      if (size == null) {
        size = [0, 0];
      }
      this.set(center, size);
    }
    Motion.ext(AABB, ClassUtils.Ext.Accessors);
    AABB.prototype.setT = function(t) {
      this.t = t;
    };
    AABB.prototype.setB = function(b) {
      this.b = b;
    };
    AABB.prototype.setL = function(l) {
      this.l = l;
    };
    AABB.prototype.setR = function(r) {
      this.r = r;
    };
    AABB.prototype.set = function(center, size) {
      this.center = center;
      if (size) {
        this.hW = size[0] || 0;
        this.hH = size[1] || 0;
      }
      this.t = this.center.j - this.hH;
      this.b = this.center.j + this.hH;
      this.l = this.center.i - this.hW;
      return this.r = this.center.i + this.hW;
    };
    AABB.prototype.intersects = function(aabb) {
      var diff, sumX, sumY;
      sumX = this.hW + aabb.hW;
      sumY = this.hH + aabb.hH;
      diff = Vector.subtract(this.center, aabb.center).abs();
      return diff.i < sumX && diff.j < sumY;
    };
    AABB.prototype.contains = function(aabb) {
      return aabb.t > this.t && aabb.b < this.b && aabb.l > this.l && aabb.r < this.r;
    };
    return AABB;
  })();
  return AABB;
});