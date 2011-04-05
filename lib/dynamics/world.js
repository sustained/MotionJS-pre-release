define(['collision/sat', 'math/vector'], function(SAT, Vector) {
  var World;
  World = (function() {
    var boundsStyle, _id;
    _id = 0;
    World.prototype.gravity = new Vector(0, 0);
    World.prototype.bodies = null;
    World.prototype.visible = {};
    function World(bounds) {
      this.bounds = bounds != null ? bounds : [100000, 100000];
      this.id = _id++;
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
    World.prototype.createCamera = function(name, size) {
      var camera;
      return camera = new Camera;
    };
    World.prototype.addEntity = function(entity) {
      entity.world = this;
      this.entities[entity.id] = entity;
      return this.bodies[entity.body.static ? 'static' : 'dynamic'][entity.id] = entity.body;
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
      var A, B, C, a, b, c, collision, i, j, k, _ref, _ref2, _ref3, _ref4, _ref5;
      _ref = this.bodies.dynamic;
      for (i in _ref) {
        a = _ref[i];
        a.collisions = [];
        A = this.entities[i];
        if (a.gravity) {
          a.applyForce(this.gravity);
        }
        if (a.collide) {
          _ref2 = this.bodies.static;
          for (j in _ref2) {
            b = _ref2[j];
            B = this.entities[j];
            if (!(A.collideWith & B.collideType) || !b.collide || !((_ref3 = a.caabb) != null ? _ref3.intersects(b.aabb) : void 0)) {
              continue;
            }
            /*
            						if not (A.collideWith & B.collideType)
            							console.log 'wrong collision type'
            							continue

            						if not b.collide
            							console.log 'not collide'
            							continue

            						if not a.caabb?.intersects b.aabb
            							console.log 'caabb doesnt intersect'
            							continue
            						*/
            collision = SAT.test(b.shape, a.shape, true);
            if (collision) {
              if (A.collide(collision, B)) {
                a.collideStatic(collision, b);
              }
            }
          }
          _ref4 = this.bodies.dynamic;
          for (k in _ref4) {
            c = _ref4[k];
            C = this.entities[k];
            if (!(A.collideWith & C.collideType) || !b.collide || !a.caabb.intersects(c.aabb) || i === k) {
              continue;
            }
            collision = SAT.test(c.shape, a.shape, false);
            if (collision) {
              if (A.collide(collision, C)) {
                a.collideDynamic(collision, c);
              }
            }
          }
        }
        a.integrate(delta);
        A.update(this.game.loop.delta, this.game.loop.tick);
      }
      _ref5 = this.bodies.static;
      for (i in _ref5) {
        a = _ref5[i];
        A = this.entities[i];
        A.update(this.game.loop.tick);
      }
    };
    World.prototype.render = function(context, camera) {
      var entity, id, _ref;
      this.drawBounds();
      _ref = this.entities;
      for (id in _ref) {
        entity = _ref[id];
        if (!camera.aabb.intersects(entity.body.aabb)) {
          continue;
        }
        entity.render(context);
      }
    };
    boundsStyle = {
      stroke: 'red',
      width: 2
    };
    World.prototype.drawBounds = function() {
      canvas.line(new Vector(0, 0), new Vector(this.w, 0), boundsStyle);
      canvas.line(new Vector(0, 0), new Vector(0, this.h), boundsStyle);
      canvas.line(new Vector(this.w, this.h), new Vector(0, this.h), boundsStyle);
      return canvas.line(new Vector(this.w, this.h), new Vector(this.w, 0), boundsStyle);
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