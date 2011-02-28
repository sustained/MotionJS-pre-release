define(['math/vector', 'classutils', 'physics/aabb'], function(Vector, ClassUtils, AABB) {
  var Body;
  Body = (function() {
    Body.prototype.shapes = [];
    Body.prototype.cof = 0.0;
    Body.prototype.coe = 0.6;
    Body.prototype.maxForce = 1;
    Body.prototype.maxSpeed = 10000;
    Body.prototype._mass = 1;
    Body.prototype._massInverse = 1;
    Body.prototype._inertia = 1;
    Body.prototype._inertiaInverse = 1;
    Body.prototype.asleep = false;
    Body.prototype.torque = 0;
    Body.prototype.orientation = 0;
    Body.prototype.angularVelocity = 0;
    Body.prototype.angularAcceleration = 0;
    function Body() {
      this.aabb = new AABB;
      this.force = new Vector;
      this.velocity = new Vector;
      this._position = new Vector;
      this.acceleration = new Vector;
    }
    extend(Body, ClassUtils.Ext.Accessors);
    Body.get('position', function() {
      return this._position;
    });
    Body.get('x', function() {
      return this._position.i;
    });
    Body.get('y', function() {
      return this._position.j;
    });
    Body.get('mass', function() {
      return this._mass;
    });
    Body.get('massInv', function() {
      return this._massInverse;
    });
    Body.get('inertia', function() {
      return this._inertia;
    });
    Body.get('inertiaInv', function() {
      return this._inertiaInverse;
    });
    Body.set('mass', function(mass) {
      return this._massInverse = 1.0 / (this._mass = mass);
    });
    Body.set('inertia', function(inertia) {
      return this._inertiaInverse = 1.0 / (this._inertia = inertia);
    });
    Body.set('position', function(_position) {
      this._position = _position;
      this.aabb.center = this._position;
      return this.shape.position = this._position;
    });
    Body.prototype.isAwake = function() {
      return !this.sleeping;
    };
    Body.prototype.isAsleep = function() {
      return this.sleeping;
    };
    Body.prototype.isMoving = function() {
      return null;
    };
    Body.prototype.isStationary = function() {
      return null;
    };
    Body.prototype.applyForce = function(force, point) {
      if (point == null) {
        point = this.position;
      }
      this.force.add(force);
      return this.torque += Vector.subtract(point, this.position).cross(force);
    };
    Body.prototype.applyTorque = function() {
      return null;
    };
    Body.prototype.linIntegrate = function(delta) {
      this.acceleration = this.force.multiply(this.massInv);
      this.velocity.add(Vector.multiply(this.acceleration, delta)).limit(this.maxSpeed);
      this.position = this.position.add(Vector.multiply(this.velocity, delta));
      return this.force.set();
    };
    Body.prototype.angIntegrate = function(delta) {
      this.angularAcceleration = this.torque * this.inertiaInv;
      this.angularVelocity += this.angularAcceleration * delta;
      this.orientation += this.angularVelocity * delta;
      return this.torque = 0;
    };
    return Body;
  })();
  return Body;
});