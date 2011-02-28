require {
	baseUrl: 'http://localhost/Shared/Javascript/MotionJS/lib/'
}, [
	'motion'
	'client/game'
	'entity'
	'camera'
	'colour'
	'geometry/polygon'
	'geometry/circle'
	'physics/collision/SAT'
], (Motion, game, Entity, Camera, Colour, Polygon, Circle, SAT) ->
	Vector = Motion.Vector
	
	###
	buffer = new Motion.Canvas [32, 768]
	buffer.create()
	
	c = buffer.context
	c.strokeStyle = 'rgb(50, 50, 50)'
	
	for x in [0..1]
		c.beginPath()
		c.moveTo x * 32, 0
		c.lineTo x * 32, 768
		c.closePath()
		
		c.stroke()
	
	for y in [0..24]
		c.beginPath()
		c.moveTo    0, y * 32
		c.lineTo 1024, y * 32
		c.closePath()
		
		c.stroke()
	
	#pixelData = c.getImageData 0, 0, 32, 768
	imageData = buffer.canvas
	###
	
	canvas = new Motion.Canvas [1680, 1050]
	canvas.create()
	
	game.Loop.context = canvas.context # make this shit automatic
	
	extend window, {game, Entity, Colour, Polygon, Circle, SAT}
	
	class EditorScreen extends Motion.Screen
		constructor: ->
			super
			
			#@colour = Colour.create('gridLines', 10, 10, 10).rgba()
			#@GUI.create 'menu', {
			#	
			#}
			
			#@xC = 1680 / 32
			#@yC = 1050 / 32
			
		update: (Game, delta, tick) ->
			
		
		render: (Game, c) ->
			c.clearRect 0, 0, 1680, 1050
			#c.fillStyle = 'black'
			#c.fillRect 0, 0, 1680, 1050
			
			#for x in [0..32]
				#c.putImageData pixelData, x * 32, 0
				#c.beginPath()
				#c.drawImage imageData, x * 32, 0
				#c.closePath()
	
	game.Screen.add 'editor', EditorScreen
	
	window.cx = canvas.context
	window.ed = game.Screen.screens.editor

	$ ->
		game.Loop.delta = 1.0 / 60
		game.Loop.start()