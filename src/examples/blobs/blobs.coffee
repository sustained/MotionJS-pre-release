require [
	'client/game'
	'screen'
	'camera'
	'canvas'
	'colour'
	'geometry/polygon'
	'geometry/circle'
	'collision/sat'
	'collision/aabb'
	'dynamics/world'
	'game/entities/blob'
	'game/entities/wall'
	'game/entities/portal'
	'game/entities/powerup'
	'game/entities/weapon'
], (Game, Screen, Camera, Canvas, Colour, Polygon, Circle, SAT, AABB, World, Blob, Wall, Portal, Powerup, Weapon) ->
	{Vector, Matrix, rand} = Math

	game = new Game size:[1024, 768], delta:1.0 / 60

	{world, canvas} = game
	
	# temporary... globals
	Motion.root.world  = world
	Motion.root.canvas = canvas
	Motion.root.globalgame = game
	
	world.w = world.h = 10000
	world.gravity = new Vector 0, 250
	
	$hW = ($W = 1024) / 2
	$hH = ($H =  768) / 2

	player1 = new Blob
	player1.body.position = new Vector $hW + 25, 100
	player1.keys = l: 'a', r: 'd', j: 'w'
	
	world.addEntity player1

	###player2 = new Blob
	player2.body.position = new Vector $hW - 25, 100
	player2.keys = l: 'left', r: 'right', j: 'up'
	
	world.addEntity player2###
	
	walls = for i in [0..1000]
		wall = new Wall
		
		coe = Math.random()
		cof = 0.01
		
		coe = 0.1 if coe < 0.1
		coe = 0.5 if coe > 0.5
		
		wall.body.coe = coe
		wall.body.cof = cof
		
		wall.body.shape.fill   = new Colour(Math.remap(coe, [0, 1], [0, 255]).round(), 0, 0).rgb()
		wall.body.shape.stroke = new Colour(0, Math.remap(cof, [0, 1], [0, 255]).round(), 0).rgb()
		
		world.addEntity wall
	
	boundaries = [
		new Wall [world.w, 10]
		new Wall [world.w, 10]
		new Wall [10, world.h]
		new Wall [10, world.h]
	]
	for wall in boundaries
		wall.body.coe = 1
		wall.body.cof = 0
		wall.body.shape.fill = new Colour(0, 0, 200, 0.8).rgba()
	
	boundaries[0].body.position = new Vector world.w / 2, 0
	boundaries[1].body.position = new Vector world.w / 2, world.w
	boundaries[2].body.position = new Vector 0, world.h / 2
	boundaries[3].body.position = new Vector world.w, world.h / 2
	
	world.addEntity wall for wall in boundaries
	
	powerups = for i in [0..100]
		powerup = new Powerup
		
		#powerup.body.collide = true
		
		world.addEntity powerup
	
	weapons = for i in [0..10]
		weapon = new Weapon
		
		weapon.body.shape.fill = 'blue'
		
		world.addEntity weapon
		
		weapon
	
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

	class GameScreen extends Screen
		constructor: ->
			super
			
			@camera = new Camera [$W, $H]
			@camera.attach player1
		
		update: (delta, tick) ->
			world.step delta
			@camera.update delta
			
			game.Input.update @camera
		
		findWeapons: ->
			for i in [0..10]
				canvas.line weapons[i].body.position, player1.body.position,
					stroke: 'rgba(100, 100, 100, 0.25)'
			return
		
		render: (context) ->
			context.clearRect 0, 0, $W, $H
			context.translate -@camera.position.i.round(), -@camera.position.j.round()
			world.render context, @camera
			@camera.render canvas
			@findWeapons()
			#canvas.circle game.Input.mouse.position.game, 2, fill: 'white'
			context.translate @camera.position.i.round(), @camera.position.j.round()

	game.Screen.add 'game', GameScreen, true

	window.world = world
	
	$ ->
		game.Loop.start()