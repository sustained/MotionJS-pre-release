var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['entity', 'geometry/polygon', 'geometry/rectangle', 'collision/aabb', 'colour'], function(Entity, Polygon, Rectangle, AABB, Colour) {
  var Powerup, Vector;
  Vector = Math.Vector;
  Powerup = (function() {
    __extends(Powerup, Entity.Static);
    function Powerup(size) {
      if (size == null) {
        size = [20, 20];
      }
      Powerup.__super__.constructor.apply(this, arguments);
      this.collideType = 0x4;
      this.body.shape = Polygon.createRectangle(size[0], size[1]);
      this.body.aabb.setExtents(this.body.shape.calculateAABBExtents());
      this.body.position = new Vector(Math.rand(50, world.w - 50), Math.rand(50, world.h - 50));
      this.going = 'up';
      this.alpha = 0.0;
      this.change = 0.01;
      this.colour = new Colour(0, 255, 0);
    }
    Powerup.prototype.update = function() {
      if (this.alpha >= 1.00) {
        this.going = 'down';
      } else if (this.alpha <= 0.00) {
        this.going = 'up';
      }
      if (this.going === 'up') {
        this.alpha += 0.01;
      } else {
        this.alpha -= 0.01;
      }
      return this.colour.a(Math.clamp(this.alpha, 0.0, 1.0));
    };
    Powerup.prototype.render = function(context) {
      this.body.shape.fill = this.colour.rgba();
      this.body.shape.draw(context);
      return canvas.polygon([new Vector(this.body.aabb.l, this.body.aabb.t), new Vector(this.body.aabb.r, this.body.aabb.t), new Vector(this.body.aabb.r, this.body.aabb.b), new Vector(this.body.aabb.l, this.body.aabb.b)], {
        stroke: 'rgba(0, 255, 0, 0.5)'
      });
    };
    Powerup.prototype.collide = function(collision) {
      return console.log(collision);
    };
    return Powerup;
  })();
  return Powerup;
});