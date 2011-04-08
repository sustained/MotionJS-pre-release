define [
	'math/vector',
	'classutils'
	'collision/aabb'
], (Vector, ClassUtils, AABB) ->
	class Body
		shapes: []
		
		cof: 0.0
		coe: 0.0
		
		density:     0.0
		friction:    0.0
		restitution: 0.0
		
		maxForce: 1
		maxSpeed: 10000
		
		_mass:    1
		_invMass: 1
		
		_inertia:    1
		_invInertia: 1
		
		asleep:  false
		gravity: true
		collide: true
		
		angle:               0
		torque:              0
		orientation:         0
		angularVelocity:     0
		angularAcceleration: 0
		
		collisions: []
		collideWith: 0
		collideType: 0
		
		shape: null
		
		# Previous position and velocity, so we can interpolate when rendering
		prevState:
			position: null
			velocity: null
		
		constructor: ->
			@aabb         = new AABB
			@force        = new Vector
			@velocity     = new Vector
			@_position    = new Vector
			#@orientation  = new Matrix
			@acceleration = new Vector
			
			@prevState.position = new Vector
			@prevState.velocity = new Vector
		
		Motion.extend Body, ClassUtils.Ext.Accessors
		
		getX: ->
			@_position.i
		
		getY: ->
			@_position.j
		
		getMass: -> @_mass
		getInertia: -> @_inertia
		getInertiaInv: -> @_invInertia
		
		setMass: ->
		setInertia: ->
		setPosition: ->
		
		@get 'position', -> @_position
		@get 'x',        -> @_position.i
		@get 'y',        -> @_position.j
		
		@get 'mass',    -> @_mass
		@get 'invMass', -> @_invMass
		
		@get 'inertia',    -> @_inertia
		@get 'invInertia', -> @_invInertia
		
		@set 'mass', (mass) ->
			@_mass    = mass
			@_invMass = if mass > 0 then 1.0 / mass else 0
		
		@set 'inertia', (inertia) ->
			@_inertia    = inertia
			@_invInertia = if inertia > 0 then 1.0 / inertia else 0
		
		@set 'position', (@_position) ->
			@aabb.setPosition @_position
			@shape.position = @_position
		
		isAwake:  -> not @sleeping
		isAsleep: -> @sleeping
		
		isMoving:     -> null
		isStationary: -> null
		
		applyForce: (force, point = @position) ->
			@force.add force
			@torque += Vector.subtract(point, @position).cross force
		
		applyTorque: ->
		
		applyImpulse: ->
			
		
		integrate: (delta) ->
			@prevState.position.set @position
			@prevState.velocity.set @velocity
			
			@acceleration = @force.multiply @invMass
			@velocity.add(Vector.multiply @acceleration, delta).limit @maxSpeed
			@position = @position.add Vector.multiply @velocity, delta
			
			#@angularAcceleration = @torque * @invInertia
			#@angularVelocity    += @angularAcceleration * delta
			
			#@angle       = Math.wrap(@angularVelocity * delta, -Math.TAU, Math.TAU)
			#@orientation.fromAngle @angle
			
			#@torque = 0
			@force.set()
			
			@aabb.set @position
		
		angIntegrate: (delta) ->
			@angularAcceleration = @torque * @invInertia
			@angularVelocity    += @angularAcceleration * delta
			@orientation        += @angularVelocity     * delta
			@torque = 0
		
		collideStatic: (collision, body) ->
			@position = @position.add collision.separation
			
			vn = Vector.multiply collision.vector, @velocity.dot collision.vector
			vt = Vector.subtract @velocity, vn
			
			@velocity = Vector.add(
				Vector.multiply(vt, 1 - body.cof),
				Vector.multiply(vn,    -body.coe)
			)
		
		collideDynamic: (collision, body) ->
			###
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
			###
			
			# totals
			te = @coe     + body.coe
			tf = @cof     + body.cof
			tm = @invMass + body.invMass
			
			# remap co-efficients to 0...1
			coe = Math.remap te, [0, 2], [0, 1]
			cof = Math.remap tf, [0, 2], [0, 1]
			
			@position     = @position.add          Vector.divide collision.separation, 2
			body.position = body.position.subtract Vector.divide collision.separation, 2
			
			v  = Vector.subtract @velocity, body.velocity
			vn = Vector.multiply collision.vector, v.dot(collision.vector)
			vt = Vector.subtract v, vn
			
			if vt.length() < 0.01 then cof = 1.01
			
			vv = Vector.add Vector.multiply(vt, -cof), Vector.multiply(vn, -(1 + coe))
			
			#    @velocity =          @velocity.add Vector.multiply(vv, 0.5)
			#body.velocity = body.velocity.subtract Vector.multiply(vv, 0.5)
			
			#@velocity = @velocity.add vv
			
			@velocity     = @velocity.add(         Vector.divide(Vector.multiply(vv,     @invMass), tm))
			body.velocity = body.velocity.subtract(Vector.divide(Vector.multiply(vv, body.invMass), tm))
