define [
	'entity'
	'math/vector'
	'geometry/polygon'
	'geometry/rectangle'
	'collision/aabb'
	'behaviours/clickable'
	'behaviours/draggable'
], (Entity, Vector, Polygon, Rectangle, AABB, BClickable, BDraggable) ->
	class Blob extends Entity.Dynamic
		health: 500
		
		jump:  false
		blink: false
		
		endBlink:   0
		startJump:  0
		startBlink: 0
		
		facingLeft:  false
		facingRight: true
		
		jumpEnd: 0
		jumpLoops: 0
		jumpStartAllowed: false
		groundBelow: true
		jumpLastImpulse: 0
		
		jumpTicker: 0
		
		keys: {}
		
		hover: ->
			#console.log 'hovered over blob!'
		
		click: ->
			#console.log 'clicked bob!'
		
		input: (input) ->
			change    = 2
			hMovement = false
			
			# parachute
			
			if input.isKeyDown('p') and @body.velocity.j >= 100
				@body.applyForce new Vector 0, -350
			
			# movement
			
			if input.isKeyDown @keys.l
				hMovement         = true
				@facingLeft       = not (@facingRight = false)
				#@body.velocity.i -= change
				@body.applyForce new Vector -150, 0
			else if input.isKeyDown @keys.r
				hMovement         = true
				@facingRight      = not (@facingLeft = false)
				#@body.velocity.i += change
				@body.applyForce new Vector 150, 0
			###else
				if @groundBelow
					if @body.velocity.i.abs() > 0.0001
						@body.velocity.i *= 0.98
					else
						@body.velocity.i = 0###
		
			# air resistance
			
			if not @groundBelow
				if @body.velocity.i.abs() > 0.0001
					@body.velocity.i *= 0.98
				else
					@body.velocity.i = 0
		
			# jumping
			
			if input.isKeyDown(@keys.j) and @groundBelow
				@body.applyForce new Vector 0, -7500
					#@jumpTicker = 0
				#else
					# hoppety hop
					#@body.applyForce new Vector 0, -4000
					# -(Math.max(150, @body.velocity.i.abs()) * 30)
		
			#if @jump is false #and @body.colliding is true
				#@jumpStart = game.Loop.tick if not @jumpStart
		
			if not @colliding then @groundBelow = false
			
			# aiming
			
			#if @hasAGun
			a = @body.position
			b = input.mouse.position.game
			
			#theta = Math.degrees Math.atan2 a.j - b.j, a.i - b.i
			theta = Math.atan2 a.j - b.j, a.i - b.i
			# make 0-360deg
			#if theta < 0 then theta += 360
			if theta < 0 then theta += Math.TWOPI
			
			# make 0deg up
			#theta = (theta + Math.TWOPI + Math.PI) % Math.TWOPI
			
			#@theta = Math.radians theta
			@theta = theta
			@logger.log Math.degrees theta
			#console.log Math.degrees(angleA).round() + ' ' + Math.degrees(angleB).round()
			
			return
		
			if @jumpAllowed is true
				if input.isKeyDown('space') or input.isKeyDown('w')
					if game.Loop.tick - @jumpLastImpulse > 0.1
						if ++@jumpLoops < 10
							@jumpLastImpulse = game.Loop.tick
							@body.applyForce new Vector 0, -(2000 * @jumpLoops)
						else
							@jumpEnd     = game.Loop.tick
							@jumpLoops   = 0
							@jumpAllowed = false
			else
				if game.Loop.tick - @jumpEnd > 2.0 then @jumpAllowed = true
		
		collide: (collision, entity) ->
			if entity.collideType is 0x1
				if collision.vector.j is 1 then @groundBelow = true
			
			if entity.collideType is 0x2
				if collision.vector.j is 1 then @groundBelow = true
			
			if entity.collideType is 0x4
				console.log 'powerup!'
				return false
			
			len = @body.velocity.lengthSquared()
			min =   90000
			max = 1000000
			
			if len >= min then @health -= Math.remap(len, [min, max], [0, 500])
			
			true
		
		update: (tick) ->
			super()
			
			@input()
			
			vel = @body.velocity.clone()
			
			if vel.i < 0
			 	@body.caabb.setLeft  Math.max 50, vel.i.abs()
				@body.caabb.setRight 50
			
			if vel.i > 0
				@body.caabb.setLeft  50
				@body.caabb.setRight Math.max 50, vel.i
			
			if vel.j < 0
				@body.caabb.setTop    Math.max 50, vel.j.abs()
				@body.caabb.setBottom 50
				
			if vel.j > 0
				@body.caabb.setTop    50
				@body.caabb.setBottom Math.max 50, vel.j
			
			@body.aabb.setPosition  @body.position
			@body.caabb.setPosition @body.position
			
			###
			vel = @body.velocity.clone().abs().multiply 2#.divide 2
		
			if vel.i < 50 then vel.i = 50
			if vel.j < 50 then vel.j = 50
		
			@body.caabb.set @body.position.clone(), [vel.i, vel.j]
			
			@body.caabb.hW = 25
			@body.caabb.hH = 25
		
			pos  = @body.position.clone()
			@body.caabb.center = pos
		
			@body.caabb.setR Math.max 25, vel.i
			@body.caabb.setL Math.max 25, Math.abs vel.i
		
			@body.caabb.setB Math.max 25, vel.j
			@body.caabb.setT Math.max 25, Math.abs vel.j
			###
			if @blink is false
				if tick - @endBlink > 4
					@blink      = true
					@startBlink = tick
			else
				if tick - @startBlink > 0.25
					@blink    = false
					@endBlink = tick
		
		drawBlob: ->
			canvas.circle @body.position.clone(), 16, fill: 'rgb(180, 180, 0)'
		
			if @jumpTicker > 0
				canvas.rectangle Vector.add(@body.position, new Vector(50,  0)), [4, 20],
					stroke: 'gray'
				canvas.rectangle Vector.add(@body.position, new Vector(50, 20)), [4, -@jumpTicker],
					fill: 'red'
			
			canvas.text Vector.add(@body.position, new Vector(50, 40)), "Vel2: #{@body.velocity.lengthSquared().toFixed(0)}",
				font: '12px Helvetica Neue', fill: 'white'
			
			canvas.text Vector.add(@body.position, new Vector(50, 20)), "|Vel|: #{@body.velocity.length().toFixed(0)}",
				font: '12px Helvetica Neue', fill: 'white'
			
			canvas.text Vector.add(@body.position, new Vector(50, 0)), "Health: #{@health.toFixed(0)}",
				font: '12px Helvetica Neue', fill: 'white'
	
		drawEyes: ->
			if @blink
				j = @body.y - 4
			
				if @facingLeft
					canvas.line new Vector(@body.x - 14, j), new Vector(@body.x - 4, j),
						stroke: 'black', width: 0.5
				else if @facingRight
					canvas.line new Vector(@body.x + 14, j), new Vector(@body.x + 4, j),
						stroke: 'black', width: 0.5
			else
				if @facingLeft
					canvas.circle new Vector(@body.x -  8, @body.y - 4), 7, fill: 'white'
					canvas.point  new Vector(@body.x - 12, @body.y - 5),    fill: 'black'
				else if @facingRight
					canvas.circle new Vector(@body.x +  8, @body.y - 4), 7, fill: 'white'
					canvas.point  new Vector(@body.x + 12, @body.y - 5),    fill: 'black'
	
		drawMouth: ->
			j = @body.y + 10
		
			if @facingLeft
				canvas.line new Vector(@body.x - 12, j), new Vector(@body.x - 2, j),
					stroke: 'black', width: 0.5
			else if @facingRight
				canvas.line new Vector(@body.x + 12, j), new Vector(@body.x + 2, j),
					stroke: 'black', width: 0.5
	
		drawAABB: ->
			#if @body.colliding
			stroke = if @body.colliding then 'rgba(200, 0, 0, 0.5)' else 'rgba(0, 200, 0, 0.5)'
			canvas.rectangle \
				@body.position.clone(),
				[@body.aabb.hw * 2, @body.aabb.hh * 2],
				mode: 'center', stroke: stroke, width: 1
			
			canvas.polygon [
				new Vector @body.caabb.l, @body.caabb.t
				new Vector @body.caabb.r, @body.caabb.t
				new Vector @body.caabb.r, @body.caabb.b
				new Vector @body.caabb.l, @body.caabb.b
			], stroke: 'rgba(0, 255, 0, 0.5)'
			###
			canvas.rectangle \
				@body.position.clone(),
				[@body.caabb.hW * 2, @body.caabb.hH * 2],
				mode: 'center', stroke: 'rgba(0, 200, 0, 0.3)'
			###
			#canvas.rectangle @body.position.clone().round(), [250, 250],
			#	stroke: 'green', mode: 'center', width: 2.0
		
		drawGun: ->
			return false if not @hasAGun
			
			if @facingLeft
				canvas.rectangle new Vector(@body.x - 28, @body.y), [12, 4], mode:'center', fill:'orange'
				canvas.rectangle new Vector(@body.x - 24, @body.y + 3), [4, 8], mode:'center', fill:'orange'
			else if @facingRight
				canvas.rectangle new Vector(@body.x + 28, @body.y), [12, 4], mode:'center', fill:'orange'
				canvas.rectangle new Vector(@body.x + 24, @body.y + 3), [4, 8], mode:'center', fill:'orange'
		
		drawCrosshairs: (context) ->
			context.translate @body.position.i, @body.position.j
			context.rotate @theta
			
			canvas.rectangle new Vector(0, 0), [20, 10], mode:'center', fill:'purple'
			
			context.rotate -@theta
			context.translate -@body.position.i, -@body.position.j
		
		render: (context) ->
			@drawBlob()
			@drawEyes()
			@drawMouth()
			@drawAABB()
			#@drawGun()
			@drawCrosshairs(context)
		
		hasAGun: false
		
		constructor: ->
			super
			
			@theta = 0
			
			@game  = new (require 'client/game')
			@input = @input.bind(@, @game.Input) if @input?
			
			@addBehaviour 'clickable', BClickable
			#@addBehaviour 'draggable', BDraggable
			
			@collideType = 0x1
			@collideWith = 0x1 | 0x2 | 0x4
			
			@body.coe      = 1.0
			@body.cof      = 0.0
			
			@body.maxSpeed = 1000
			
			@body.shape = Polygon.createRectangle 26, 26 #new Rectangle 26
			@body.caabb = new AABB @body.position, 50
			
			@body.aabb.set @body.position, 13
			
			@logger = new Logger 500
			
			#@event.on 'collision', (collision, entity) ->
			#	if collision.vector.j is 1 then @groundBelow = true
	
	Blob