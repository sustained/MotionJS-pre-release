var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['entity', 'geometry/polygon', 'geometry/rectangle', 'collision/aabb', 'colour'], function(Entity, Polygon, Rectangle, AABB, Colour) {
  var Vector, Weapon;
  Vector = Math.Vector;
  Weapon = (function() {
    __extends(Weapon, Entity.Dynamic);
    function Weapon(size) {
      if (size == null) {
        size = [20, 20];
      }
      Weapon.__super__.constructor.apply(this, arguments);
      this.collideWith = 0x1 | 0x2;
      this.collideType = 0x8;
      this.body.shape = Polygon.createRectangle(size[0], size[1]);
      this.body.aabb.setExtents(this.body.shape.calculateAABBExtents());
      this.body.caabb = new AABB(this.body.position, 20);
      this.body.position = new Vector(Math.rand(50, world.w - 50), Math.rand(50, world.h - 50));
    }
    Weapon.prototype.update = function() {
      var vel;
      vel = this.body.velocity.clone();
      if (vel.i < 0) {
        this.body.caabb.setLeft(Math.max(50, vel.i.abs()));
      }
      this.body.caabb.setRight(50);
      if (vel.i > 0) {
        this.body.caabb.setLeft(50);
        this.body.caabb.setRight(Math.max(50, vel.i));
      }
      if (vel.j < 0) {
        this.body.caabb.setTop(Math.max(50, vel.j.abs()));
        this.body.caabb.setBottom(50);
      }
      if (vel.j > 0) {
        this.body.caabb.setTop(50);
        this.body.caabb.setBottom(Math.max(50, vel.j));
      }
      this.body.aabb.setPosition(this.body.position);
      return this.body.caabb.setPosition(this.body.position);
    };
    Weapon.prototype.render = function(context) {
      return this.body.shape.draw(context);
    };
    Weapon.prototype.collide = function(collision, entity) {
      if (entity.collideType === 0x1) {
        entity.hasAGun = true;
        this.world.removeEntity(this.id);
        false;
      }
      return true;
    };
    return Weapon;
  })();
  return Weapon;
});