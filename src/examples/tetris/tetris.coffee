require {
	baseUrl: 'http://localhost/Shared/Javascript/MotionJS/lib/'
}, [
	'motion'
	'client/game'
], (Motion, ClientGame) ->
	game = window.game = new ClientGame
	
	# convenience
	randX = rand.bind null, 0, 1024 
	randY = rand.bind null, 0,  768
	
	class One extends Motion.Screen
		zIndex: 1
		
		constructor: ->
			super
			
			@nospam = 0
			
		update: (Game, delta, tick) ->
			#if tick - @nospam > 0.5
			#	@nospam = tick
			#	console.log ['one', "\t", tick.toFixed(2), "\t", @tick.toFixed(2)].join ''
			
			#if @tick.round() >= 5
			#	Game.Screen.disable @name
			#	Game.Loop.context.clearRect 0, 0, 1024, 768
			#	Game.Screen.enable 'two'
				
		render: (Game, context) ->
			context.clearRect 0, 0, 1024, 768
			
			context.fillStyle = 'red'
			context.fillRect -20 + (1024 / 2), -20 + (768 / 2), 50, 50
	
	class Two extends Motion.Screen
		zIndex: 2
		
		constructor: ->
			super
			
			@nospam = 0
		
		update: (Game, delta, tick) ->
			#if tick - @nospam > 0.5
			#	@nospam = tick
			#	console.log ['two', "\t", tick.toFixed(2), "\t", @tick.toFixed(2)].join ''
			
			#if @tick.round() >= 5
			#	Game.Screen.disable @name
			#	Game.Loop.context.clearRect 0, 0, 1024, 768
			#	Game.Screen.enable 'one'
		
		render: (Game, context) ->
			context.clearRect 0, 0, 1024, 768
			
			context.beginPath()
			context.arc 1024 / 2, 768 / 2, 15, Math.TAU, false
			context.closePath()
			
			context.fillStyle = 'blue'
			context.fill()
	
	canvas = new Motion.Canvas
	canvas.create()
	
	game.Loop.context = canvas.context
	
	game.Screen.add 'one', One
	game.Screen.add 'two', Two
	
	console.log game.Screen.enabled
	console.log game.Screen.sort()
	
	game.Loop.start()