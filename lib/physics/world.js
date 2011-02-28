define(['physics/collision/SAT', 'math/vector'], function(SAT, Vector) {
  var World;
  World = (function() {
    World.prototype.gravity = new Vector(0, 0);
    function World(bounds) {
      this.bounds = bounds != null ? bounds : [10000, 10000];
      this.w = this.bounds[0];
      this.h = this.bounds[1];
      this.groups = {
        player: {},
        static: {},
        dynamic: {}
      };
      this.cameras = {};
      this.entities = {};
    }
    World.prototype.addEntity = function(entity) {
      this.entities[entity.id] = entity;
      if (entity.body.static) {
        return this.groups.static[entity.id] = entity;
      } else {
        return this.groups.dynamic[entity.id] = entity;
      }
    };
    World.prototype.step = function(delta) {
      var a, b, collision, collisions, i, j, m, n, skips, vn, vt, _ref, _ref2, _ref3;
      _ref = this.groups.player;
      for (n in _ref) {
        i = _ref[n];
        i.input(this.game.Input);
      }
      _ref2 = this.groups.dynamic;
      for (n in _ref2) {
        i = _ref2[n];
        if (i.body.isAsleep()) {
          continue;
        }
        i.body.applyForce(this.gravity);
        i.damping();
        skips = 0;
        collisions = 0;
        _ref3 = this.groups.static;
        for (m in _ref3) {
          j = _ref3[m];
          a = i.body;
          b = j.body;
          if (!a.caabb.intersects(b.aabb)) {
            continue;
          }
          collision = SAT.test(b.shape, a.shape);
          if (collision) {
            collisions++;
            a.position = a.position.add(collision.separation);
            vn = Vector.multiply(collision.vector, a.velocity.dot(collision.vector));
            vt = Vector.subtract(a.velocity, vn);
            a.velocity = Vector.add(Vector.multiply(vt, 1 - b.cof), Vector.multiply(vn, -b.coe));
            b.colliding = true;
            i.event.fire('collision', [collision, j]);
          } else {
            b.colliding = false;
          }
        }
        a.colliding = collisions > 0;
        i.body.linIntegrate(delta);
        i.update(this.game.Loop.tick);
      }
      return;
    };
    World.prototype.render = function(context, camera) {
      var entity, id, _ref, _ref2;
      _ref = this.groups.static;
      for (id in _ref) {
        entity = _ref[id];
        if (!camera.aabb.intersects(entity.body.aabb)) {
          continue;
        }
        entity.render(context);
      }
      _ref2 = this.groups.dynamic;
      for (id in _ref2) {
        entity = _ref2[id];
        if (!camera.aabb.intersects(entity.body.aabb)) {
          continue;
        }
        entity.render(context);
      }
      return;
    };
    World.prototype.randomV = function() {
      return new Vector(this.randomX(), this.randomY());
    };
    World.prototype.randomX = function() {
      return Math.rand(0, this.bounds[0]);
    };
    World.prototype.randomY = function() {
      return Math.rand(0, this.bounds[1]);
    };
    return World;
  })();
  return World;
});