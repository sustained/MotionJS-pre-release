define(['collision/aabb', 'client/input/keyboard', 'client/input/mouse'], function(AABB, Keyboard, Mouse) {
  var Camera, Vector;
  Vector = Math.Vector;
  return Camera = (function() {
    var EDGE_MOVE_DISTANCE, EDGE_MOVE_MAXSPEED;
    Camera.prototype.entity = null;
    Camera.prototype.origin = 'center';
    function Camera(bounds) {
      if (bounds == null) {
        bounds = [1024, 768];
      }
      this.hw = (this.w = bounds[0]) / 2;
      this.hh = (this.h = bounds[1]) / 2;
      this.aabb = new AABB(null, {
        t: this.hh,
        b: this.hh,
        l: this.hw,
        r: this.hw
      });
      this.position = new Vector;
      this.input = this.input.bind(this, Keyboard.instance(), Mouse.instance());
    }
    EDGE_MOVE_DISTANCE = 200;
    EDGE_MOVE_MAXSPEED = 2.5;
    Camera.prototype.input = function(kb, ms) {
      var move, speed;
      speed = 2;
      if (kb.keys.shift) {
        EDGE_MOVE_MAXSPEED = 10;
      } else {
        EDGE_MOVE_MAXSPEED = 5;
      }
      if (kb.keys.left) {
        this.position.i -= speed;
      } else if (kb.keys.right) {
        this.position.i += speed;
      }
      if (kb.keys.up) {
        this.position.j -= speed;
      } else if (kb.keys.down) {
        this.position.j += speed;
      }
      if (ms.position.i < EDGE_MOVE_DISTANCE) {
        move = -Math.remap(Math.abs(EDGE_MOVE_DISTANCE - ms.position.i), [0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED]);
      } else if (ms.position.i > (this.w - EDGE_MOVE_DISTANCE)) {
        move = Math.remap(Math.abs(EDGE_MOVE_DISTANCE - (this.w - ms.position.i)), [0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED]);
      } else {
        move = 0;
      }
      this.position.i = this.position.i + Math.min(EDGE_MOVE_MAXSPEED, move);
      if (ms.position.j < EDGE_MOVE_DISTANCE) {
        move = -Math.remap(Math.abs(EDGE_MOVE_DISTANCE - ms.position.j), [0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED]);
      } else if (ms.position.j > (this.h - EDGE_MOVE_DISTANCE)) {
        move = Math.remap(Math.abs(EDGE_MOVE_DISTANCE - (this.h - ms.position.j)), [0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED]);
      } else {
        move = 0;
      }
      return this.position.j = this.position.j + Math.min(EDGE_MOVE_MAXSPEED, move);
    };
    Camera.prototype.update = function(delta, tick) {
      if (this.entity) {
        this.position.i = this.entity.body.x - (this.w / 2);
        this.position.j = this.entity.body.y - (this.h / 2);
        this.aabb.setPosition(this.entity.body.position);
      } else {
        this.input();
      }
      if (this.origin === 'topleft') {
        return this.aabb.setPosition(Vector.add(this.position, new Vector(this.hw, this.hh)));
      } else if (this.origin === 'center') {
        return this.aabb.setPosition(this.position);
      }
    };
    Camera.prototype.render = function(canvas) {
      return canvas.rectangle(this.position, [this.aabb.w, this.aabb.h], {
        stroke: 'red',
        width: 5
      });
    };
    Camera.prototype.attach = function(entity) {
      return this.entity = entity;
    };
    return Camera;
  })();
});