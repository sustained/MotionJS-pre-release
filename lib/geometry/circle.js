var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['motion', 'geometry/shape'], function(Motion, Shape) {
  var Circle;
  Circle = (function() {
    __extends(Circle, Shape);
    Circle.prototype.radius = 0;
    function Circle(radius, position) {
      this.radius = radius;
      Circle.__super__.constructor.call(this, position);
    }
    Circle.get('radiusT', function() {
      return this.radius * this._scaleX;
    });
    Circle.prototype.draw = function(graphics) {
      if (this.fill) {
        graphics.fillStyle = this.fill;
      }
      if (this.stroke) {
        graphics.strokeStyle = this.stroke;
      }
      graphics.beginPath();
      graphics.arc(this.position.i, this.position.j, this.radiusT, 0, Math.TAU, false);
      return graphics.closePath();
    };
    return Circle;
  })();
  return Circle;
});