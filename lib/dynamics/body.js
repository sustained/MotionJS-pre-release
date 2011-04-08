define(['math/vector', 'classutils', 'collision/aabb'], function(Vector, ClassUtils, AABB) {
  var Body;
  return Body = (function() {
    Body.prototype.shapes = [];
    Body.prototype.cof = 0.0;
    Body.prototype.coe = 0.0;
    Body.prototype.density = 0.0;
    Body.prototype.friction = 0.0;
    Body.prototype.restitution = 0.0;
    Body.prototype.maxForce = 1;
    Body.prototype.maxSpeed = 10000;
    Body.prototype._mass = 1;
    Body.prototype._invMass = 1;
    Body.prototype._inertia = 1;
    Body.prototype._invInertia = 1;
    Body.prototype.asleep = false;
    Body.prototype.gravity = true;
    Body.prototype.collide = true;
    Body.prototype.angle = 0;
    Body.prototype.torque = 0;
    Body.prototype.orientation = 0;
    Body.prototype.angularVelocity = 0;
    Body.prototype.angularAcceleration = 0;
    Body.prototype.collisions = [];
    Body.prototype.collideWith = 0;
    Body.prototype.collideType = 0;
    Body.prototype.shape = null;
    Body.prototype.prevState = {
      position: null,
      velocity: null
    };
    function Body() {
      this.aabb = new AABB;
      this.force = new Vector;
      this.velocity = new Vector;
      this._position = new Vector;
      this.acceleration = new Vector;
      this.prevState.position = new Vector;
      this.prevState.velocity = new Vector;
    }
    Motion.extend(Body, ClassUtils.Ext.Accessors);
    Body.prototype.getX = function() {
      return this._position.i;
    };
    Body.prototype.getY = function() {
      return this._position.j;
    };
    Body.prototype.getMass = function() {
      return this._mass;
    };
    Body.prototype.getInertia = function() {
      return this._inertia;
    };
    Body.prototype.getInertiaInv = function() {
      return this._invInertia;
    };
    Body.prototype.setMass = function() {};
    Body.prototype.setInertia = function() {};
    Body.prototype.setPosition = function() {};
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
      this.aabb.setPosition(this._position);
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
    Body.prototype.applyTorque = function() {};
    Body.prototype.applyImpulse = function() {};
    Body.prototype.integrate = function(delta) {
      this.prevState.position.set(this.position);
      this.prevState.velocity.set(this.velocity);
      this.acceleration = this.force.multiply(this.invMass);
      this.velocity.add(Vector.multiply(this.acceleration, delta)).limit(this.maxSpeed);
      this.position = this.position.add(Vector.multiply(this.velocity, delta));
      this.force.set();
      return this.aabb.set(this.position);
    };
    Body.prototype.angIntegrate = function(delta) {
      this.angularAcceleration = this.torque * this.invInertia;
      this.angularVelocity += this.angularAcceleration * delta;
      this.orientation += this.angularVelocity * delta;
      return this.torque = 0;
    };
    Body.prototype.collideStatic = function(collision, body) {
      var vn, vt;
      this.position = this.position.add(collision.separation);
      vn = Vector.multiply(collision.vector, this.velocity.dot(collision.vector));
      vt = Vector.subtract(this.velocity, vn);
      return this.velocity = Vector.add(Vector.multiply(vt, 1 - body.cof), Vector.multiply(vn, -body.coe));
    };
    Body.prototype.collideDynamic = function(collision, body) {
      /*
      			Vector V = Va – Vb; // relative velocity
      			Vn = (V . N) * N;
      			Vt = V – Vn;

      			if (Vt.Length() < 0.01f) friction = 1.01f;

      			// response
      			V’ = Vt * -(friction) + Vn  * -(1 + elasticity);

      			Va += V’ * 0.5f;
      			Vb -= V’ * 0.5f;

      			Va += V’ * (InvMassA) / (InvMassA + InvMassB);
      			Vb -= V’ * (InvMassB) / (InvMassA + InvMassB);
      			*/      var coe, cof, te, tf, tm, v, vn, vt, vv;
      te = this.coe + body.coe;
      tf = this.cof + body.cof;
      tm = this.invMass + body.invMass;
      coe = Math.remap(te, [0, 2], [0, 1]);
      cof = Math.remap(tf, [0, 2], [0, 1]);
      this.position = this.position.add(Vector.divide(collision.separation, 2));
      body.position = body.position.subtract(Vector.divide(collision.separation, 2));
      v = Vector.subtract(this.velocity, body.velocity);
      vn = Vector.multiply(collision.vector, v.dot(collision.vector));
      vt = Vector.subtract(v, vn);
      if (vt.length() < 0.01) {
        cof = 1.01;
      }
      vv = Vector.add(Vector.multiply(vt, -cof), Vector.multiply(vn, -(1 + coe)));
      this.velocity = this.velocity.add(Vector.divide(Vector.multiply(vv, this.invMass), tm));
      return body.velocity = body.velocity.subtract(Vector.divide(Vector.multiply(vv, body.invMass), tm));
    };
    return Body;
  })();
});