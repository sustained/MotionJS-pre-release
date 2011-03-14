define(['physics/collision/SAT', 'math/vector'], function(SAT, Vector) {
  var World;
  World = (function() {
    World.prototype.gravity = new Vector(0, 0);
    function World(bounds) {
      this.bounds = bounds != null ? bounds : [Number.MAX_VALUE, Number.MAX_VALUE];
      this.w = this.bounds[0];
      this.h = this.bounds[1];
      this.groups = {
        player: {},
        static: {},
        dynamic: {}
      };
      this.bodies = {
        static: {},
        dynamic: {}
      };
      this.cameras = {};
      this.entities = {};
    }
    World.prototype.addEntity = function(entity) {
      this.entities[entity.id] = entity;
      if (entity.body.static) {
        return this.bodies.static[entity.id] = entity.body;
      } else {
        return this.bodies.dynamic[entity.id] = entity.body;
      }
    };
    World.prototype.removeEntity = function(id) {
      if (id in this.entities) {
        delete this.entities[id];
        if (id in this.bodies.static) {
          delete this.bodies.static[id];
        }
        if (id in this.bodies.dynamic) {
          delete this.bodies.dynamic[id];
        }
        true;
      }
      return false;
    };
    World.prototype.step = function(delta) {
      var A, B, a, b, collision, collisions, entity, i, j, n, skips, vn, vt, _ref, _ref2, _ref3;
      _ref = this.groups.player;
      for (n in _ref) {
        entity = _ref[n];
        entity.input(this.game.Input);
      }
      /*
      				Broad phase
      			*/
      /*
      				Narrow phase
      			*/
      _ref2 = this.bodies.dynamic;
      for (i in _ref2) {
        a = _ref2[i];
        if (a.isAsleep()) {
          continue;
        }
        A = this.entities[i];
        a.applyForce(this.gravity);
        skips = 0;
        collisions = 0;
        _ref3 = this.bodies.static;
        for (j in _ref3) {
          b = _ref3[j];
          if (!a.caabb.intersects(b.aabb)) {
            continue;
          }
          B = this.entities[j];
          collision = SAT.test(b.shape, a.shape);
          if (collision) {
            collisions++;
            a.position = a.position.add(collision.separation);
            vn = Vector.multiply(collision.vector, a.velocity.dot(collision.vector));
            vt = Vector.subtract(a.velocity, vn);
            a.velocity = Vector.add(Vector.multiply(vt, 1 - b.cof), Vector.multiply(vn, -b.coe));
            B.colliding = true;
            A.event.fire('collision', [collision, b]);
          } else {
            B.colliding = false;
          }
        }
        /*
        				for m, j of @bodies.dynamic
        					continue if not i.caabb.intersects j.aabb

        					collision = SAT.test i.shape, j.shape

        					if collision
        						i.event.fire 'collision', [collision, j]
        						j.event.fire 'collision', [collision, i]
        				*/
        A.colliding = collisions > 0;
        a.linIntegrate(delta);
        A.update(this.game.Loop.tick);
      }
    };
    World.prototype.render = function(context, camera) {
      var entity, id, _ref;
      _ref = this.entities;
      for (id in _ref) {
        entity = _ref[id];
        if (!camera.aabb.intersects(entity.body.aabb)) {
          continue;
        }
        entity.render(context);
      }
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