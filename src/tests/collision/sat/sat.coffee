define [
	'client/game'
	'dynamics/world'
	'geometry/circle'
	'geometry/polygon'
	'collision/aabb'
	'screen'
	'entity'
	'camera'
	'animation/animation'
	'animation/easing'
], (Game, World, Circle, Polygon, AABB, Screen, Entity, Camera, Animation, Easing) ->
	game = new Game
	
	{Vector} = Math
	{Colour} = Motion
	
	Motion.root.world      = game.world
	Motion.root.canvas     = game.canvas
	Motion.root.globalgame = game
	
	world.bounds = [world.w, world.h] = [1024, 768]
	
	class Foo extends Entity.Static
		constructor: ->
			super
			
			@collideType = 0x1
			
			size = rand(10, 20)#[rand(10, 100), rand(10, 100)]
			
			@body.coe = 0.5
			
			@body.shape = Polygon.createShape rand(3, 8), size, size
			
			@body.aabb.setExtents @body.shape.calculateAABBExtents()
			
			@body.shape.fill = new Colour 255, 0, 0, 0.25
			
			@body.position = world.randomV()
		
		render: (context) ->
			@body.shape.draw context
			
			canvas.polygon [
				new Vector @body.aabb.l, @body.aabb.t
				new Vector @body.aabb.r, @body.aabb.t
				new Vector @body.aabb.r, @body.aabb.b
				new Vector @body.aabb.l, @body.aabb.b
			], stroke: 'rgba(0, 255, 0, 0.5)'
	
	world.addEntity new Foo for i in [0...10]
	
	class Bar extends Entity.Dynamic
		controls: null
		
		constructor: ->
			super
			
			@collideType = 0x2
			@collideWith = 0x1 | 0x2
			
			size = 30
			
			@body.coe = 0.0
			@body.cof = 0.5
			
			@body.shape = Polygon.createRectangle size, size
			
			@body.aabb.setExtents 15
			@body.shape.fill = new Colour 0, 0, 255, 0.25
			
			@body.position = world.randomV()
			
			@body.caabb = new AABB @body.position, 50
		
		collide: (collision, entity) ->
			true
		
		update: (delta, tick) ->
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
			extents.l = if vel.i < 0 then vel.i.abs() else 50
			extents.r = if vel.i > 0 then vel.i       else 50
			extents.t = if vel.j < 0 then vel.j.abs() else 50
			extents.b = if vel.j > 0 then vel.j       else 50
			###
		
		input: ->
			if game.Input.isKeyDown @controls.l
				@body.velocity.i -= 5
			else if game.Input.isKeyDown @controls.r
				@body.velocity.i += 5
			else
				if @body.velocity.i.abs() < 0.001
					@body.velocity.i = 0
				else
					@body.velocity.i *= 0.97
			
			if game.Input.isKeyDown @controls.u
				@body.velocity.j -= 5
			else if game.Input.isKeyDown @controls.d
				@body.velocity.j += 5
			else
				if @body.velocity.j.abs() < 0.001
					@body.velocity.j = 0
				else
					@body.velocity.j *= 0.97
				
		
		render: (context) ->
			@body.shape.draw context
			
			canvas.rectangle \
				@body.position.clone(),
				[@body.aabb.w, @body.aabb.h],
				mode: 'center', stroke: 'rgba(0, 255, 0, 0.5)', width: 1
			
			canvas.polygon [
				new Vector @body.caabb.l, @body.caabb.t
				new Vector @body.caabb.r, @body.caabb.t
				new Vector @body.caabb.r, @body.caabb.b
				new Vector @body.caabb.l, @body.caabb.b
			], stroke: 'rgba(0, 255, 0, 0.5)'
	
	player1 = window.player1 = new Bar
	player2 = window.player2 = new Bar
	player1.body.mass = 100
	
	player1.controls = u:'w', d:'s', l:'a', r:'d'
	player2.controls = u:'up', d:'down', l:'left', r:'right'
	
	world.addEntity player1
	#world.addEntity player2
	
	class GameScreen extends Screen
		constructor: ->
			super
			
			@camera = new Camera [1024, 768]
			@camera.attach world.entities[player1.id]
			#@camera.entity = null
			
			@test = new Animation
				start:     0.25
				end:       1.0
				#easing:    Easing.Vector.cubeEaseIn
				duration:  10
				reference: player1.body.shape.fill
			
			#@test.play()
		
		update: (delta, tick) ->
			world.step     delta
			@camera.update delta
			
			@test.update delta
			
			game.Input.update @camera
		
		render: (context) ->
			context.clearRect 0, 0, 1024, 768
			context.translate -@camera.position.i.round(), -@camera.position.j.round()
			world.render context, @camera
			#@camera.render canvas
			#canvas.circle game.Input.mouse.position.game, 2, fill: 'white'
			context.translate @camera.position.i.round(), @camera.position.j.round()
	
	game.Screen.add 'game', GameScreen, true
	Motion.root.screen = game.Screen.screens.game
	
	jQuery ->
		game.loop.start()
