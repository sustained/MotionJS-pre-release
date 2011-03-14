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
	#'http://localhost:8080/socket.io/socket.io.js'
], (Game, Entity, Camera, Canvas, Colour, Vector, Polygon, Circle, SAT, World, AABB, Screen) ->
	game = new Game
	
	rand   = Math.rand
	world  = game.world
	canvas = game.canvas
	
	$hW = ($W = 1024) / 2
	$hH = ($H =  768) / 2
	
	world.gravity = new Vector 0, 0
	
	###
	socket = new io.Socket 'localhost', port: 8080
	console.log socket
	
	socket.on 'connect', ->
		console.log 'connected'
		
	socket.on 'message', (msg) ->
		console.log "message #{msg}"
		
	socket.on 'disconnect', ->
		console.log 'disconnected'
	
	socket.connect()
	###
	
	class EditorScreen extends Screen
		constructor: ->
			super
			
			@run = true
			@camera = new Camera [$W, $H], moveable: true
			
			@xLines = $W / 4
			@yLines = $H / 4
		
		input: (Input) ->
			if Input.isKeyDown 'left'
				@camera.position.i -= 2
			else if Input.isKeyDown 'right'
				@camera.position.i += 2
			if Input.isKeyDown 'up'
				@camera.position.j -= 2
			else if Input.isKeyDown 'down'
				@camera.position.j += 2
		
		update: (delta, tick) ->
			@input game.Input
			
			if @run then world.step delta
			
			@camera.update delta
			game.Input.update @camera
		
		render: (context) ->
			canvas.clear()
			
			context.translate -@camera.position.i, -@camera.position.j

			context.font         = '10px "Helvetica CY"'
			context.textAlign    = 'center'
			context.textBaseline = 'middle'
			
			canvas.text new Vector(0, 0), '0', fill: 'lightgray'
			
			x = 1; xl = 1024 / 32; while x <= xl
				canvas.text new Vector(x * 32, 10), x * 32, fill: 'lightgray'
				x++
			
			y = 1; yl = 768 / 32; while y <= yl
				canvas.text new Vector(10, y * 32), y * 32, fill: 'lightgray'
				y++
			###
			x = 0; xl = 1024 / 32; while x <= xl
				y = 0; yl = 768 / 32; while y <= yl
					canvas.rectangle new Vector(x * 32, y * 32), [32, 32],
						fill: if x & 1
							if y & 1 then '#050505' else '#101010'
						else
							if y & 1 then '#101010' else '#050505'
					
					canvas.text new Vector((x * 32) - 16, (y * 32) - 16), "#{x} , #{y}", fill: '#bdbdbd'
					
					y++
				
				x++
			###
			world.render context, @camera
			
			context.translate @camera.position.i, @camera.position.j
	
	game.Screen.add 'editor', EditorScreen, true
	
	$ ->
		game.Loop.start()