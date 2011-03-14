define(['math/vector', 'classutils', 'physics/aabb'], function(Vector, ClassUtils, AABB) {
  var Body;
  Body = (function() {
    Body.prototype.shapes = [];
    Body.prototype.cof = 0.0;
    Body.prototype.coe = 0.6;
    Body.prototype.maxForce = 1;
    Body.prototype.maxSpeed = 10000;
    Body.prototype._mass = 1;
    Body.prototype._invMass = 1;
    Body.prototype._inertia = 1;
    Body.prototype._invInertia = 1;
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
    Motion.ext(Body, ClassUtils.Ext.Accessors);
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
    Body.get('invMass', function() {
      return this._invMass;
    });
    Body.get('inertia', function() {
      return this._inertia;
    });
    Body.get('invInertia', function() {
      return this._invInertia;
    });
    Body.set('mass', function(mass) {
      this._mass = mass;
      return this._invMass = mass > 0 ? 1.0 / mass : 0;
    });
    Body.set('inertia', function(inertia) {
      this._inertia = inertia;
      return this._invInertia = inertia > 0 ? 1.0 / inertia : 0;
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
      this.acceleration = this.force.multiply(this.invMass);
      this.velocity.add(Vector.multiply(this.acceleration, delta)).limit(this.maxSpeed);
      this.position = this.position.add(Vector.multiply(this.velocity, delta));
      return this.force.set();
    };
    Body.prototype.angIntegrate = function(delta) {
      this.angularAcceleration = this.torque * this.invInertia;
      this.angularVelocity += this.angularAcceleration * delta;
      this.orientation += this.angularVelocity * delta;
      return this.torque = 0;
    };
    return Body;
  })();
  return Body;
});