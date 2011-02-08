game = (Motion, Game, Screen, Canvas, Vector, Colour) ->
	Game = window.Game = new Game
	window.Screen = Screen
	console.log Screen
	console.log Game.Screen
	
	#canvas = new Canvas 'canvastest'
	#canvas.create();
	
	###
	class StateTest extends State
		constructor: ->
			super Game
			
			@speed    = if rand(1) is 0 then -3 else 3
			@position = new Vector rand(1024), rand(768)
			@setColour()
		
		update: (Game, tick, delta) ->
			@position.i += @speed #* rand @speed
			@position.j += @speed #* rand @speed
			if @speed > 0
				@position.i = 0 if @position.i > 1024
				@position.j = 0 if @position.j >  768
			else
				@position.i = 1024 if @position.i < 0
				@position.j =  768 if @position.j < 0
			
			if @position.i is    0 or @position.j is   0 \
			or @position.i is 1024 or @position.j is 768
				@setColour()
		
		setColour: ->
			@colour = Colour.random(false).r(0).b(0).a(0.2).rgba()
		
		render: (Game, alpha, context) ->
			context.beginPath()
			context.arc @position.i, @position.j, rand(2, 4), 0, Math.TAU, false
			context.closePath()
			
			context.strokeStyle = @colour
			context.stroke()
	
	100.times (n) ->
		state = new StateTest Game
		Game.State.create "test#{n}", state, true
	
	last = 0
	Game.State.Event.on 'beforeRender', (Game, alpha, context) ->
		if Game.Loop.update - last > 600
			last = Game.Loop.update
			canvas.clear()
	###
	
	Game.Loop.delta = 1.0 / 30
	Game.Loop.context = canvas.context
	#Game.Loop.start()

require baseUrl: 'http://localhost/Shared/Javascript/MotionJS/lib/', [
	'motion'
	'client/game'
	'screen'
	'canvas'
	'vector'
	'colour'
], game