define [
	'math/vector',
	'classutils'
	'physics/aabb'
], (Vector, ClassUtils, AABB) ->
	class Body
		shapes: []
		
		cof: 0.0
		coe: 0.6
		
		maxForce: 1
		maxSpeed: 10000
		
		_mass:    1
		_invMass: 1
		
		_inertia:    1
		_invInertia: 1
		
		asleep: false
		
		torque:              0
		orientation:         0
		angularVelocity:     0
		angularAcceleration: 0
		
		constructor: ->
			@aabb         = new AABB
			@force        = new Vector
			@velocity     = new Vector
			@_position    = new Vector
			@acceleration = new Vector
		
		Motion.ext Body, ClassUtils.Ext.Accessors
		
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
			@aabb.center    = @_position
			@shape.position = @_position
		
		isAwake:  -> not @sleeping
		isAsleep: -> @sleeping
		
		isMoving:     -> null
		isStationary: -> null
		
		applyForce: (force, point = @position) ->
			@force.add force
			@torque += Vector.subtract(point, @position).cross force
		
		applyTorque: ->
			null
		
		linIntegrate: (delta) ->
			@acceleration = @force.multiply @invMass
			@velocity.add(Vector.multiply(@acceleration, delta)).limit @maxSpeed
			@position = @position.add(Vector.multiply(@velocity, delta))
			@force.set()
		
		angIntegrate: (delta) ->
			@angularAcceleration = @torque * @invInertia
			@angularVelocity    += @angularAcceleration * delta
			@orientation        += @angularVelocity     * delta
			@torque = 0
	
	Body