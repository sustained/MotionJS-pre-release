define(['classutils', 'math/vector'], function(ClassUtils, Vector) {
  var AABB;
  return AABB = (function() {
    AABB.prototype.local = null;
    AABB.prototype.world = null;
    AABB.prototype.h = 0;
    AABB.prototype.w = 0;
    AABB.prototype.hh = 0;
    AABB.prototype.hw = 0;
    AABB.prototype._isSquare = false;
    AABB.prototype.render = function(style) {
      return canvas.polygon([new Vector(this.world.l, this.world.t), new Vector(this.world.r, this.world.t), new Vector(this.world.r, this.world.b), new Vector(this.world.l, this.world.b)], style);
    };
    function AABB(position, extents) {
      if (extents == null) {
        extents = {};
      }
      this.local = {
        t: 0,
        b: 0,
        l: 0,
        r: 0
      };
      this.world = {
        t: 0,
        b: 0,
        l: 0,
        r: 0
      };
      this.position = new Vector;
      this.set(position, extents);
    }
    AABB.prototype.setTop = function(top) {
      return this.local.t = top;
    };
    AABB.prototype.setBottom = function(bottom) {
      return this.local.b = bottom;
    };
    AABB.prototype.setLeft = function(left) {
      return this.local.l = left;
    };
    AABB.prototype.setRight = function(right) {
      return this.local.r = right;
    };
    /*
    		#	Set the AABBs size via a width and height.
    		*/
    AABB.prototype.setDimensions = function(size) {
      this.hh = (this.h = size[1]) / 2;
      this.hw = (this.w = size[0]) / 2;
      this._isSquare = this.h === this.w;
      this.local.t = this.hh;
      this.local.b = this.hh;
      this.local.l = this.hw;
      return this.local.r = this.hw;
    };
    /*
    		#	Set the AABBs size via a top, bottom, left and right value.
    		*/
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
      this.local = Motion.extend(this.local, extents);
      this.hh = (this.h = this.local.t + this.local.b) / 2;
      this.hw = (this.w = this.local.l + this.local.r) / 2;
      return this._isSquare = this.h === this.w;
    };
    /*
    		#	Set the world position of the AABB, updates the worldExtents.
    		*/
    AABB.prototype.setPosition = function(position) {
      if (!position) {
        return;
      }
      this.position.copy(position);
      this.world.t = this.position.j - this.local.t;
      this.world.b = this.position.j + this.local.b;
      this.world.l = this.position.i - this.local.l;
      return this.world.r = this.position.i + this.local.r;
    };
    /*
    		#	Set the position and/or extents of the AABB.
    		*/
    AABB.prototype.set = function(position, extents) {
      this.setPosition(position);
      if (isObject(extents)) {
        return this.setExtents(extents);
      } else if (isArray(extents)) {
        return this.setDimensions(extents);
      }
    };
    AABB.prototype.intersects = function(aabb) {
      var diff;
      diff = Vector.subtract(this.position, aabb.position).abs();
      return diff.j < this.hh + aabb.hh && diff.i < this.hw + aabb.hw;
    };
    AABB.prototype.contains = function(aabb) {
      return aabb.world.t > this.world.t && aabb.world.b < this.world.b && aabb.world.l > this.world.l && aabb.world.r < this.world.r;
    };
    AABB.prototype.containsPoint = function(v) {
      return v.j > this.world.t && v.j < this.world.b && v.i > this.world.l && v.i < this.world.r;
    };
    return AABB;
  })();
});