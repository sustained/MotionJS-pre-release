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
		
		_mass:        1
		_massInverse: 1
		
		_inertia:        1
		_inertiaInverse: 1
		
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
		
		extend Body, ClassUtils.Ext.Accessors
		
		@get 'position', -> @_position
		@get 'x',        -> @_position.i
		@get 'y',        -> @_position.j
		
		@get 'mass',    -> @_mass
		@get 'massInv', -> @_massInverse
		
		@get 'inertia',    -> @_inertia
		@get 'inertiaInv', -> @_inertiaInverse
		
		@set 'mass',    (mass)    -> @_massInverse    = 1.0 / (@_mass    = mass)
		@set 'inertia', (inertia) -> @_inertiaInverse = 1.0 / (@_inertia = inertia)
		
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
			@acceleration = @force.multiply @massInv
			@velocity.add(Vector.multiply(@acceleration, delta)).limit @maxSpeed
			@position = @position.add(Vector.multiply(@velocity, delta))
			@force.set()
		
		angIntegrate: (delta) ->
			@angularAcceleration = @torque * @inertiaInv
			@angularVelocity    += @angularAcceleration * delta
			@orientation        += @angularVelocity     * delta
			@torque = 0
	
	Body