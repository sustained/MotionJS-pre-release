var camera;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
camera = function(Motion, Entity) {
  var Camera;
  return Camera = (function() {
    __extends(Camera, Entity);
    Camera.prototype.drawAABB = false;
    Camera.prototype.drawCorners = false;
    function Camera() {
      this["super"]();
      this.position.set(0, 0);
      this.setDimensions(1024, 768);
    }
    Camera.prototype.getAABB = function() {
      return {};
    };
    Camera.prototype.getCorners = function() {
      return {};
    };
    Camera.prototype.render = noop;
    Camera.prototype.renderAABB = noop;
    Camera.prototype.renderCorners = noop;
    Camera.prototype.update = function(Game, t, dt) {
      var speed;
      speed = Game.Input.keyboard.shift ? 256 : 64;
      if (Game.Input.isKeyDown('left')) {
        this.velocity.i = -speed;
      } else if (Game.Input.isKeyDown('right')) {
        this.velocity.i = speed;
      } else {
        this.velocity.i = 0;
      }
      if (Game.Input.isKeyDown('up')) {
        this.velocity.j = -speed;
      } else if (Game.Input.isKeyDown('down')) {
        this.veocity.j = speed;
      } else {
        this.velocity.j = 0;
      }
      return this.updateVectors(dt);
    };
    Camera.prototype.centerOn = function(vector) {
      this.position.i = vector.i = this.radius[0];
      return this.position.j = vector.j = this.radius[1];
    };
    return Camera;
  })();
};
define(['motion', 'entity'], camera);