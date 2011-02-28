require [
	'client/game'
	'entity'
	'camera'
	'canvas'
	'colour'
	'math/vector'
	'geometry/polygon'
	'geometry/circle'
	'physics/collision/SAT'
	'physics/world'
	'physics/aabb'
	'screen'
], (Game, Entity, Camera, Canvas, Colour, Vector, Polygon, Circle, SAT, World, AABB, Screen) ->
	game = new Game
	
	rand = Math.rand
	
	$hW = ($W = 1024) / 2
	$hH = ($H =  768) / 2

	world = new World [5000, 5000]
	world.game = game
	world.gravity = new Vector 0, 300

	canvas = new Canvas [$W, $H]
	canvas.create()
	
	# make this shit automatic
	game.Loop.context = canvas.context
	game.Input.setup canvas.$canvas

	extend window, {game, world, canvas}

	class Wall extends Entity.Static
		constructor: (size = [rand(100, 400), rand(20, 40)]) ->
			super
			
			@body.shape    = Polygon.createRectangle size[0], size[1]
			@body.position = new Vector rand(50, world.w - 50), rand(50, world.h - 50)
			@body.aabb     = new AABB @body.position, [size[0] / 2, size[1] / 2]
		
		render: (context) ->
			@body.shape.draw context
			return
			stroke = if @body.colliding then 'rgba(200, 0, 0, 0.5)' else 'rgba(0, 200, 0, 0.5)'
			#if @body.colliding
			canvas.rectangle \
				@body.position.clone(),
				[@body.aabb.hW * 2, @body.aabb.hH * 2],
				mode: 'center', stroke: stroke, width: 1
	
	class Portal extends Entity.Dynamic
		@lastPortalUse: 0
		
		constructor: ->
			super
			
			@event.on 'collision', (collision, entity) ->
				if game.Loop.tick - Portal.lastPortalUse > 0.5
					entity.body.position = @portal.body.position.clone()
					Portal.lastPortalUse = game.Loop.tick
			
			@body.shape = Polygon.createSquare 32
		
		#update: ->
		#	@body.shape.fill = @colour.a(game.Loop.alpha).rgba()
		
		render: (context) ->
			@body.shape.draw context
	
	class MovingBlock extends Entity.Dynamic
		constructor: ->
			super
			
			@body.shape = Polygon.createRectangle [100, 20]
	
	class Blob extends Entity.Dynamic
		constructor: ->
			super
			
			@body.maxSpeed = 1000
			@body.shape = Polygon.createSquare 26
			@body.caabb = new AABB @body.position, [250, 250]
			
			@body.aabb.set @body.position, [13, 13]
			
			@event.on 'collision', (collision, entity) ->
				if collision.vector.j is 1 then @groundBelow = true
		
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
		groundBelow: false
		jumpLastImpulse: 0
		
		jumpTicker: 0
		
		input: (input) ->
			#change = if @body.colliding then 8 else 4
			change = 2
			
			
			#if input.isKeyDown 'jump'
			#	
			#else if @groundBelow
			#	hop impulse
			#
			
			hMovement = false
			
			if input.isKeyDown 'a'
				hMovement         = true
				@facingLeft       = not (@facingRight = false)
				@body.velocity.i -= change
			else if input.isKeyDown 'd'
				hMovement         = true
				@facingRight      = not (@facingLeft = false)
				@body.velocity.i += change
			
			if input.isKeyDown 'w'
				@jumpTicker += 0.5 if @jumpTicker <= 20
			else
				if @groundBelow
					if @jumpTicker > 0
						@body.applyForce new Vector 0, -(1000 * @jumpTicker)
						@jumpTicker = 0
					else
						# hoppety hop
						@body.applyForce new Vector 0, -4000#(Math.max(150, @body.velocity.i.abs()) * 30)
			
			if not hMovement
				if @body.velocity.i.abs() > 0.005
					@body.velocity.i *= 0.97
				else
					@body.velocity.i = 0
			
			#if @jump is false #and @body.colliding is true
				#@jumpStart = game.Loop.tick if not @jumpStart
			
			if not @colliding then @groundBelow = false
			
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
		
		update: (tick) ->
			vel = @body.velocity.clone().abs()
			if vel.i < 50 then vel.i = 50
			if vel.j < 50 then vel.j = 50
			
			@body.caabb.set @body.position.clone(), [vel.i, vel.j]
			
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
				canvas.rectangle Vector.add(@body.position, new Vector(50,  0)), [4, 20], stroke: 'gray'
				canvas.rectangle Vector.add(@body.position, new Vector(50, 20)), [4, -@jumpTicker], fill: 'red'
			
			canvas.text Vector.add(@body.position, new Vector(50, 50)), @body.velocity.length().toFixed(0), font: '12px Helvetica Neue', fill: 'white'
		
		drawEyes: ->
			if @blink
				j = @body.y - 4
				
				if @facingLeft
					canvas.line new Vector(@body.x - 14, j), new Vector(@body.x - 4, j), stroke: 'black', width: 0.5
				else if @facingRight
					canvas.line new Vector(@body.x + 14, j), new Vector(@body.x + 4, j), stroke: 'black', width: 0.5
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
				canvas.line new Vector(@body.x - 12, j), new Vector(@body.x - 2, j), stroke: 'black', width: 0.5
			else if @facingRight
				canvas.line new Vector(@body.x + 12, j), new Vector(@body.x + 2, j), stroke: 'black', width: 0.5
		
		drawAABB: ->
			#if @body.colliding
			stroke = if @body.colliding then 'rgba(200, 0, 0, 0.5)' else 'rgba(0, 200, 0, 0.5)'
			canvas.rectangle \
				@body.position.clone(),
				[@body.aabb.hW * 2, @body.aabb.hH * 2],
				mode: 'center', stroke: stroke, width: 1
			
			canvas.rectangle \
				@body.position.clone(),
				[@body.caabb.hW * 2, @body.caabb.hH * 2],
				mode: 'center', stroke: 'rgba(0, 200, 0, 0.3)'
			#canvas.rectangle @body.position.clone().round(), [250, 250], stroke: 'green', mode: 'center', width: 2.0
		
		render: (context) ->
			@drawBlob()
			@drawEyes()
			@drawMouth()
			#@drawAABB()

	player = new Blob
	player.body.position = new Vector $hW, 5
	world.groups.player[player.id] = player
	world.addEntity player
	
	walls = for i in [0..100]
		wall = new Wall
		#wall.body.cof = Math.random()
		coe = Math.random()
		coe = 0.3 if coe < 0.3
		coe = 0.7 if coe > 0.7
		wall.body.coe = 0.1
		wall.body.cof = 0.0
		
		wall.body.shape.fill = Colour.random()
		#wall.body.shape.stroke = new Colour(200, 0, 0, wall.body.cof).rgba()
		wall

	boundaries = [
		new Wall [world.w, 20]
		new Wall [world.w, 20]
		new Wall [20, world.h]
		new Wall [20, world.h]
	]
	for wall in boundaries
		#wall.body.cof = 0.0
		wall.body.coe = 5.0
		wall.body.shape.fill = new Colour(0, 0, 200, 0.8).rgba()
	
	boundaries[0].body.position = new Vector world.w / 2, 0
	boundaries[1].body.position = new Vector world.w / 2, world.w
	boundaries[2].body.position = new Vector 0, world.h / 2
	boundaries[3].body.position = new Vector world.w, world.h / 2
	
	#boundaries[0].body.position = new Vector $hW, 0
	#boundaries[1].body.position = new Vector $hW, $H
	#boundaries[2].body.position = new Vector 0,   $hH
	#boundaries[3].body.position = new Vector $W,  $hH

	walls = walls.concat boundaries

	world.addEntity wall for wall in walls
	
	#portals = for i in [0..10]
	#	portal = new Portal
	#	portal.body.position = world.randomV()
	#	portal.body.shape.fill = 'rgb(0, 255, 0)'
	#	portal
	
	###
	portals[0].body.position = new Vector 50, $hH
	portals[1].body.position = new Vector $hW, 50
	portals[2].body.position = new Vector $W - 50, $hH
	portals[3].body.position = new Vector $hW, $H - 50
	
	portals[0].portal = portals[1]
	portals[1].portal = portals[0]
	
	portals[2].portal = portals[3]
	portals[3].portal = portals[2]
	###
	
	#world.addEntity portal for portal in portals
	
	#mid = new Vector $hW, $hH
	#top = new Vector $hW, 50

	logTime = 0
	log = window.log = (me) ->
		now = Date.now()
	
		if now - logTime > 250
			logTime = now
			console.log me
	
	class GameScreen extends Screen
		constructor: ->
			super
			
			@camera = new Camera [$W, $H]
			@camera.attach world.groups.player[1]
		
		update: (delta, tick) ->
			world.step     delta
			@camera.update delta
			
			game.Input.update @camera
		
		render: (context) ->
			context.clearRect 0, 0, $W, $H
			context.translate -@camera.position.i, -@camera.position.j
			world.render context, @camera
			#@camera.render canvas
			#canvas.circle game.Input.mouse.position.game, 2, fill: 'white'
			context.translate @camera.position.i, @camera.position.j
	###
	class Renderer
		@create: (render) -> render.bind canvas.context

	EditorPolyShapeRenderer = Renderer.create (shape) ->
		verts = shape.verticesT
	
		@beginPath()
		@moveTo verts[0].i, verts[0].j
		@lineTo vertex.i, vertex.j for vertex in verts
		@lineTo verts[0].i, verts[0].j
		@closePath()
	
		if shape.fill
			@fillStyle = shape.fill
			@fill()
	
		if shape.stroke
			@strokeStyle = shape.stroke
			@stroke()

	EditorCollRenderer = Renderer.create (shape) ->
		EditorPolyShapeRenderer shape
	
		@fillStyle = 'white'
		@fillText 'Collision Block', shape.x, shape.y

	EditorTrigRenderer = Renderer.create (shape) ->
		EditorPolyShapeRenderer shape
	
		@fillStyle = 'white'
		@fillText 'Trigger', shape.x, shape.y

	EditorRectShapeRenderer = Renderer.create (shape) ->

	EditorCircShapeRenderer = Renderer.create (shape) ->
		@beginPath()
		@arc shape.position.i, shape.position.j, shape.radiusT, 0, Math.TAU, false
		@closePath()
	
		if shape.fill
			@fillStyle = shape.fill
			@fill()
	
		if shape.stroke
			@strokeStyle = shape.stroke
			@stroke()

	EditorPlayerRenderer = Renderer.create (player) ->
		@fillStyle = 'red'
		@fillRect player.x - 13, player.y - 13, 26, 26

	class EditorScreen extends Motion.Screen
		constructor: ->
			super
	
		blur:  -> console.log 'editor screen blurred'
		focus: ->
			console.log 'editor screen focused'
		
			strokeColour = new Colour(0, 0, 200).rgb()
			fillColour   = new Colour(0, 0, 150, 0.6).rgba()
		
			for shape in world.shapes
				shape.fill   = fillColour
				shape.stroke = strokeColour
		
			strokeColour = new Colour(0, 255, 0).rgb()
		
			for trigger in world.triggers
				trigger.fill   = false
				trigger.stroke = strokeColour
	
		update: (Game, delta, tick) ->
	
		render: (Game, context) ->
			context.clearRect 0, 0, 1024, 768
		
			EditorPlayerRenderer world.player
		
			for shape in world.shapes
				EditorCollRenderer shape
		
			for trigger in world.triggers
				EditorTrigRenderer trigger
	###

	#game.Screen.add 'editor', EditorScreen, false
	game.Screen.add 'game', GameScreen, true

	window.world = world
	
	$ ->
		game.Loop.delta = 1.0 / 60
		game.Loop.start()
		
		#setTimeout (-> game.Loop.stop()), 100

###
e.colliding = false

for shape, i in world.shapes
	test = SAT.test shape, world.player.shape
	done = false

	if test
		if shape.fill is 'blue'
			if tick - @lastPortalUse > 0.5
				e.position     = shape.portal.position.clone()
				@lastPortalUse = tick
			break
	
		e.colliding = true
	
		#@shapes[i].stroke = Colour.get('red').rgba()
		#hits++
		log "#{test.vector}\t#{test.overlap.toFixed(2)}"
		#console.log "Separation: #{test.separation}"
		#console.log "Unit Vector: #{test.unitVector}"
		#console.log e.acceleration.debug()
	
		e.position = e.position.add test.separation
	
		#if test.vector.i > 0
		#	cof = 0.3
	
		if test.vector.j is 1
			e.jump = false if e.jump
		#Vn = (V . N) * N;
		#Vt = V – Vn;
		#V’ = Vt * (1 – friction) + Vn  * -(elasticity);
	
		vn = Vector.multiply test.vector, e.velocity.dot(test.vector)
		vt = Vector.subtract e.velocity, vn
	
		#console.log vt.length()
	
		#console.log vt.debug()
		#if vt.length() < 10
		#	vt = Vector.multiply vt, 0.98
	
		#if vt.length() < 0.5
		#	cof = 1.01
	
		v  = Vector.add Vector.multiply(vt, 1 - cof), Vector.multiply(vn, -coe)
		e.velocity = v
		#e.acceleration.j = 0
		#e.velocity.j     = 0
	
		#console.log test.vector.debug()
		#e.velocity.add Vector.multiply test.separation, 100
		#e.force.add Vector.multiply test.separation, 100
	else
		#@shapes[i].stroke = Colour.get('green').rgba()
###

###
@map = [
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1]
	[1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
	[1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1]
	[1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
]
@mapWidth  = @map[0].length
@mapHeight = @map.length
###