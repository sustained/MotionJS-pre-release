define [
	'loop'
	'physics/world'
	'geometry/circle'
	'geometry/polygon'
], (Game, World, Circle, Polygon) ->
	gloop = new Loop
	gloop.delta = 1.0 / 60
	
	world = new World [1024, 768]
	
	canvas = new Canvas [1024, 768]
	canvas.create()
	
	game.Loop.context = canvas.context
	game.Input.setup canvas.$canvas
	
	rect1 = Polygon.createRectangle 100, 100, new Vector  0, 0
	rect2 = Polygon.createRectangle  20, 100, new Vector 20, 0
	circ1 = new Circle 50, new Vector 100, 100
	circ2 = new Circle 50, new Vector 200, 200
	poly1 = Polygon.createShape 3, 100, new Vector 100, 20
	poly2 = Polygon.createShape 3, 100, new Vector 0, 50
	
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
	