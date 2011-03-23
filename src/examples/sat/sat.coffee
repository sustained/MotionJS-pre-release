require [
	'client/game'
	'entity'
	'camera'
	'canvas'
	'colour'
	'math/vector'
	'geometry/polygon'
	'geometry/circle'
	'collision/SAT'
	'dynamics/world'
	'screen'
], (Game, Entity, Camera, Canvas, Colour, Vector, Polygon, Circle, SAT, World, Screen) ->
	game = new Game
	
	rand = Math.rand
	
	$hW = ($W = 1680) / 2
	$hH = ($H = 1050) / 2

	world = new World [$W, $H]
	world.game = game
	world.gravity = new Vector 0, 300

	canvas = new Canvas [$W, $H]
	canvas.create()
	
	game.Loop.context = canvas.context # make this shit automatic

	extend window, {game, world, canvas, SAT}

	class Wall extends Entity.Static
		constructor: (size = [rand(20, 80), rand(20, 80)]) ->
			super
			
			@body.shape      = Polygon.createRectangle size[0], size[1]
			@body.shape.fill = 'red'
			#@body.position = world.randomV()
		
		render: (context) ->
			@body.shape.draw context
	
	wall1 = new Wall [10, 10]
	wall1.body.position = new Vector 10, 10
	
	wall2 = new Wall [10, 10]
	wall2.body.position = new Vector 20, 20
	
	walls = [wall1, wall2]
	
	extend window, {
		e1: walls[0], b1: walls[0].body, s1: walls[0].body.shape
		e2: walls[1], b2: walls[1].body, s2: walls[1].body.shape
	}
	
	###
	boundaries = [
		new Wall [$W, 20]
		new Wall [$W, 20]
		new Wall [20, $H]
		new Wall [20, $H]
	]
	for wall in boundaries
		wall.body.coe = 1.0
		wall.body.shape.fill = new Colour(200, 0, 0).rgb()

	boundaries[0].body.position = new Vector $hW, 0
	boundaries[1].body.position = new Vector $hW, $H
	boundaries[2].body.position = new Vector 0,   $hH
	boundaries[3].body.position = new Vector $W,  $hH

	walls = walls.concat boundaries
	###
	world.addEntity wall for wall in walls
	
	class GameScreen extends Screen
		constructor: ->
			super
		
		update: (delta, tick) ->
			world.step delta
		
		render: (context) ->
			context.clearRect 0, 0, $W, $H
			world.render context
	
	game.Screen.add 'game', GameScreen, true

	window.world = world
	
	$ ->
		game.Loop.hideFPS()
		game.Loop.delta = 1.0 / 60
		game.Loop.start()
		
		#console.log SAT.test s1, s2