var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['entity', 'geometry/polygon', 'geometry/rectangle', 'collision/aabb'], function(Entity, Polygon, Rectangle, AABB) {
  var Vector, Wall;
  Vector = Math.Vector;
  Wall = (function() {
    __extends(Wall, Entity.Static);
    function Wall(size) {
      if (size == null) {
        size = [Math.rand(100, 400), Math.rand(20, 40)];
      }
      Wall.__super__.constructor.apply(this, arguments);
      this.collideType = 0x2;
      this.body.shape = Polygon.createRectangle(size[0], size[1]);
      this.body.aabb.setExtents(this.body.shape.calculateAABBExtents());
      this.body.position = new Vector(Math.rand(50, world.w - 50), Math.rand(50, world.h - 50));
    }
    Wall.prototype.render = function(context) {
      this.body.shape.draw(context);
      return canvas.polygon([new Vector(this.body.aabb.l, this.body.aabb.t), new Vector(this.body.aabb.r, this.body.aabb.t), new Vector(this.body.aabb.r, this.body.aabb.b), new Vector(this.body.aabb.l, this.body.aabb.b)], {
        stroke: 'rgba(0, 255, 0, 0.5)'
      });
    };
    return Wall;
  })();
  return Wall;
});