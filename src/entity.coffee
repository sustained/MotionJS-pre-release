define [
	'motion'
	'eventful'
	'colour'
], (Motion, Eventful, Colour) ->
	Vector = Motion.Vector
	
	class Entity
		extend Entity, Motion.ClassUtils.Ext.Accessors
		
		active: no
		
		width:  0
		height: 0
		
		maxSpeed: 1000
		maxForce: 1
		
		_mass:        1
		_massInverse: 1
		
		_inertia:        1
		_inertiaInverse: 1
		
		torque:              0
		orientation:         0
		angularVelocity:     0
		angularAcceleration: 0
		
		drawAABB:    no
		drawCorners: no
		
		constructor: (@shape) ->
			#@State = new Motion.Stateful
			@Event = new Eventful
			
			@colour = Colour.random()
			@radius = []
			
			@force        = new Vector
			@velocity     = new Vector
			@position     = new Vector
			@acceleration = new Vector
			
			@activeBehaviours = []
			@behaviours = {}
			
			@setDimensions 32, 32
		
		@get 'mass',    -> @_mass
		@get 'massInv', -> @_massInverse
		
		@get 'inertia',    -> @_inertia
		@get 'inertiaInv', -> @_inertiaInverse
		
		@set 'mass',    (mass)    -> @_massInverse    = 1.0 / (@_mass    = mass)
		@set 'inertia', (inertia) -> @_inertiaInverse = 1.0 / (@_inertia = inertia)
		
		isMoving: ->
			null
		
		isStationary: ->
			null
		
		addForce: (force, position = new Vector) ->
			@force.add Vector.rotate force, @orientation
			@torque += position.perpDot force
		
		addBehaviour: (name, behaviour) ->
			@behaviours[name] = behaviour
			
		
		updateVectors: (dt) ->
			if @mass isnt Infinity
				@acceleration        = @force.multiply @massInv
				@angularAcceleration = @torque * @inertiaInv
				
				@velocity.add(Vector.multiply @acceleration, dt).limit @maxSpeed
				@angularVelocity += @angularAcceleration * dt
				
				@position.add Vector.multiply @velocity, dt
				@orientation += @angularVelocity * dt
				
				@orientation = Math.TAU if @orientation < 0
				@orientation = 0        if @orientation > Math.TAU
			
			@force.set()
			@torque = 0
		
		update: (Game, delta, tick) ->
			for i in @activeBehaviours
				@behaviours[i].update tick
			
			@updateVectors delta
		
		render: (Game, context, alpha) ->
			for i in @activeBehaviours
				@behaviours[i].render alpha
			
			#@renderAABB    Game, a, cx if @drawAABB    is on
			#@renderCorners Game, a, cx if @drawCorners is on
		
		###
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
		###
		setDimensions: (width, height) ->
			@width  = width
			@height = height
			@radius = [width / 2, height / 2]
	
	Entity