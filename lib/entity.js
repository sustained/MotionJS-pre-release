define(['motion', 'eventful', 'colour'], function(Motion, Eventful, Colour) {
  var Entity, Vector;
  Vector = Motion.Vector;
  Entity = (function() {
    extend(Entity, Motion.ClassUtils.Ext.Accessors);
    Entity.prototype.active = false;
    Entity.prototype.width = 0;
    Entity.prototype.height = 0;
    Entity.prototype.maxSpeed = 1000;
    Entity.prototype.maxForce = 1;
    Entity.prototype._mass = 1;
    Entity.prototype._massInverse = 1;
    Entity.prototype._inertia = 1;
    Entity.prototype._inertiaInverse = 1;
    Entity.prototype.torque = 0;
    Entity.prototype.orientation = 0;
    Entity.prototype.angularVelocity = 0;
    Entity.prototype.angularAcceleration = 0;
    Entity.prototype.drawAABB = false;
    Entity.prototype.drawCorners = false;
    function Entity(shape) {
      this.shape = shape;
      this.Event = new Eventful;
      this.colour = Colour.random();
      this.radius = [];
      this.force = new Vector;
      this.velocity = new Vector;
      this.position = new Vector;
      this.acceleration = new Vector;
      this.activeBehaviours = [];
      this.behaviours = {};
      this.setDimensions(32, 32);
    }
    Entity.get('mass', function() {
      return this._mass;
    });
    Entity.get('massInv', function() {
      return this._massInverse;
    });
    Entity.get('inertia', function() {
      return this._inertia;
    });
    Entity.get('inertiaInv', function() {
      return this._inertiaInverse;
    });
    Entity.set('mass', function(mass) {
      return this._massInverse = 1.0 / (this._mass = mass);
    });
    Entity.set('inertia', function(inertia) {
      return this._inertiaInverse = 1.0 / (this._inertia = inertia);
    });
    Entity.prototype.isMoving = function() {
      return null;
    };
    Entity.prototype.isStationary = function() {
      return null;
    };
    Entity.prototype.addForce = function(force, position) {
      if (position == null) {
        position = new Vector;
      }
      this.force.add(Vector.rotate(force, this.orientation));
      return this.torque += position.perpDot(force);
    };
    Entity.prototype.addBehaviour = function(name, behaviour) {
      return this.behaviours[name] = behaviour;
    };
    Entity.prototype.updateVectors = function(dt) {
      if (this.mass !== Infinity) {
        this.acceleration = this.force.multiply(this.massInv);
        this.angularAcceleration = this.torque * this.inertiaInv;
        this.velocity.add(Vector.multiply(this.acceleration, dt)).limit(this.maxSpeed);
        this.angularVelocity += this.angularAcceleration * dt;
        this.position.add(Vector.multiply(this.velocity, dt));
        this.orientation += this.angularVelocity * dt;
        if (this.orientation < 0) {
          this.orientation = Math.TAU;
        }
        if (this.orientation > Math.TAU) {
          this.orientation = 0;
        }
      }
      this.force.set();
      return this.torque = 0;
    };
    Entity.prototype.update = function(Game, delta, tick) {
      var i, _i, _len, _ref;
      _ref = this.activeBehaviours;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        this.behaviours[i].update(tick);
      }
      return this.updateVectors(delta);
    };
    Entity.prototype.render = function(Game, context, alpha) {
      var i, _i, _len, _ref, _results;
      _ref = this.activeBehaviours;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        _results.push(this.behaviours[i].render(alpha));
      }
      return _results;
    };
    /*
    		renderAABB: (Game, a, cx) ->
    			pos      = @position
    			[hX, hY] = @radius

    			cx.beginPath()
    			cx.moveTo pos.i - hX, pos.j - hY
    			cx.lineTo pos.i + hX, pos.j - hY
    			cx.lineTo pos.i + hX, pos.j + hY
    			cx.lineTo pos.i - hX, pos.j + hY
    			cx.lineTo pos.i - hX, pos.j - hY
    			cx.closePath()

    			cx.strokeStyle = Motion.Colour.red.rgba()
    			cx.stroke()

    		renderCorners: (Game, a, cx) ->
    			x = @getCorners()

    			cx.beginPath()
    			cx.moveTo x.tl.i      x.tl.j + 4
    			cx.lineTo x.tl.i,     x.tl.j
    			cx.lineTo x.tl.i + 4, x.tl.j

    			cx.moveTo x.tr.i - 4, x.tr.j
    			cx.lineTo x.tr.i,     x.tr.j
    			cx.lineTo x.tr.i,     x.tr.j + 4

    			cx.moveTo x.br.i,     x.br.j - 4
    			cx.lineTo x.br.i,     x.br.j
    			cx.lineTo x.br.i - 4, x.br.j

    			cx.moveTo x.bl.i + 4, x.bl.j
    			cx.lineTo x.bl.i,     x.bl.j
    			cx.lineTo x.bl.i,     x.bl.j - 4
    			cx.closePath()

    			cx.lineWidth   = 2
    			cx.strokeStyle = 'rgba(255, 0, 0, 0.8)'
    			cx.stroke()

    		getAABB: ->
    			l: @position.i - @radius[0]
    			r: @position.i + @radius[0]
    			t: @position.j - @radius[1]
    			b: @position.j + @radius[1]

    		getCorners: ->
    			tl: new Vector @position.i - @radius[0], @position.j - @radius[1]
    			tr: new Vector @position.i + @radius[0], @position.j - @radius[1]
    			br: new Vector @position.i + @radius[0], @position.j + @radius[1]
    			bl: new Vector @position.i - @radius[0], @position.j + @radius[1]

    		intersects: (aabb) ->
    			me = @getAABB()

    			return false if aabb.b <= me.t
    			return false if aabb.t >= me.b
    			return false if aabb.r <= me.l
    			return false if aabb.l >= me.r
    			true
    		*/
    Entity.prototype.setDimensions = function(width, height) {
      this.width = width;
      this.height = height;
      return this.radius = [width / 2, height / 2];
    };
    return Entity;
  })();
  return Entity;
});