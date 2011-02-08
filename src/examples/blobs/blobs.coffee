require {
	baseUrl: 'http://localhost/Shared/Javascript/MotionJS/lib/'
}, [
	'motion'
	'client/game'
	'entity'
	'colour'
	'geometry/polygon'
	'geometry/circle'
	'physics/collision/SAT'
], (Motion, ClientGame, Entity, Colour, Polygon, Circle, SAT) ->
	game = new ClientGame
	
	Vector = Motion.Vector
	
	# convenience
	randX  = rand.bind null, 0, 1024 
	randY  = rand.bind null, 0,  768
	randV  = -> new Vector randX(), randY()
	middle = new Vector 1024 / 2, 768 / 2
	
	canvas = new Motion.Canvas
	canvas.create()
	
	game.Loop.context = canvas.context
	
	extend window, {game, Entity, Colour, Polygon, Circle, SAT}
	
	class GameScreen extends Motion.Screen
		constructor: ->
			super
			
			spawnTop = new Vector 1024 / 2, 0
			spawnMid = middle.clone()
			
			@entity = new Entity Polygon.createSquare 32, spawnTop.clone()
			#@entity.maxSpeed = 100
			@entity.position = spawnTop.clone()
			
			@shapes = [
				#new Circle 16, spawnTop
				#new Circle 200, spawnMid
				#Polygon.createRectangle  50,  50, spawnTop
				#Polygon.createRectangle 200, 200, spawnMid
				#Polygon.createShape 4,  50, spawnTop
				#Polygon.createShape 6, 200, spawnMid
			]
			
			xCells = 1024 / 32
			yCells =  768 / 32
			
			for i in [0...20]
				# a small (in the lower half) x and y
				xS = rand(0, xCells / 2) * xCells
				yS = rand(0, yCells / 2) * yCells
				
				# a large (in the upper half) x and y
				xL = rand(xCells / 2, xCells) * xCells
				yL = rand(yCells / 2, yCells) * yCells
				
				if rand(0, 1) is 0
					w = xS
					h = yL
				else
					w = xL
					h = yS
				
				@shapes.push Polygon.createRectangle xS / 2, yS / 2, randV()
				#@shapes.push Polygon.createRectangle w, h, randV()
			
			shape.stroke = Colour.random(false).a(1.0).rgba() for shape in @shapes
			
			#@polygons.unshift new Circle 16, new Vector middle.i, 0
			#@polygons = [
				#player
				
				#Polygon.createShape 4, rand( 10,  20), new Vector middle.i, 0
				
				# obstacles
				
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				#Polygon.createShape 4, rand(100, 200), new Vector randX(), randY()
				
				#new Circle 20, middle.clone()
				#new Circle 20, new Vector middle.i / 2, 0
			#]
			
			#test = SAT.test @polygons[0], @polygons[1]
			#console.log test
			#@polygons[1].position = @polygons[1].position.add test.seperation
			
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
			
			@jmp = false
			@jmpTime = 0
		
		update: (Game, delta, tick) ->
			#mapX = Math.floor @entity.position.i / 32
			#mapY = Math.floor @entity.position.j / 32
			
			e = @entity
			
			# gravity
			#e.addForce new Vector 0, 30
			#e.position.j = 0 if e.position.j > 768
			
			# reverse gravity
			#e.y = e.y - 5
			#e.y = 768 if e.y < 0
			
			#if Game.Input.isKeyDown 'w'
			#	e.y = e.y - 5
			#else if Game.Input.isKeyDown 's'
			#	e.y = e.y + 5
			
			#if @jmp is false
			#	if Game.Input.isKeyDown 'w' \
			#	or Game.Input.isKeyDown 'space'
			#		e.addForce new Vector 0, -10
			#		@jmp = true
			
			if Game.Input.isKeyDown 'w'
				e.velocity.j = -200
			else if Game.Input.isKeyDown 's'
				e.velocity.j = 200
			else
				if e.velocity.j.abs() > 0.00005
					e.velocity.j *= 0.8
				else
					e.velocity.j = 0
			
			if Game.Input.isKeyDown 'a'
				e.velocity.i = -200
			else if Game.Input.isKeyDown 'd'
				e.velocity.i = 200
			else
				if e.velocity.i.abs() > 0.00005
					e.velocity.i *= 0.8
				else
					e.velocity.i = 0
			
			#hits    = 0
			#gravity = false
			
			e.velocity.j = e.velocity.j + 50
			
			for shape, i in @shapes
				#continue if i is 0
				
				test = SAT.test @shapes[i], @entity.shape
				
				if test
					#hits++
					#console.log "Overlap: #{test.overlap}"
					#console.log "Separation: #{test.separation}"
					#console.log "Unit Vector: #{test.unitVector}"
					
					#gravity = true if test.unitVector.j isnt 1
					
					#e.position = e.position.add test.separation
					e.velocity.add Vector.multiply test.separation, 100
			
			e.updateVectors delta
			
			#if hits is 0 or gravity
			#	e.addForce new Vector 0, 1000
			
			e.position.j = 0 if e.position.j > 768

			e.shape.position = e.position
			
			return
			
			if test
				console.log "Overlap: #{test.overlap}"
				console.log "Separation: #{test.separation}"
				console.log "Unit Vector: #{test.unitVector}"
				
				@shapes[0].stroke = Colour.get('red').rgba()
			else
				@shapes[0].stroke = Colour.get('green').rgba()
			
			return
			
			# gravity
			@entity.addForce new Vector 0, 200
			
			if Game.Input.isKeyDown 'a'
				@entity.addForce new Vector -50, 0
			else if Game.Input.isKeyDown 'd'
				@entity.addForce new Vector 50, 0
			else
				if @entity.velocity.i.abs() > 0.00005
					@entity.velocity.i *= 0.9
				else
					@entity.velocity.i = 0
			
			@entity.position.j = 0 if @entity.position.j > 768
			
			@entity.update Game, delta, tick
		
		render: (Game, context) ->
			context.clearRect 0, 0, 1024, 768
			
			@entity.shape.draw context
			context.strokeStyle = 'green'
			context.stroke();
			
			for shape in @shapes
				shape.draw context
				#context.strokeStyle = 'green'
				#context.lineWidth = 1.0
				context.stroke()
			return
			
			context.fillStyle = 'gray'
			
			for j in [0...@mapHeight]
				for i in [0...@mapWidth]
					cell = @map[j][i]
					continue if cell is 0
					context.fillRect i * 32, j * 32, 32, 32
			
			context.fillStyle = 'yellow'
			
			context.beginPath()
			context.arc @entity.position.i, @entity.position.j, 16, 0, Math.TAU, false
			context.closePath()
			
			context.fill()
			
			context.fillStyle = 'black'
			context.fillRect @entity.position.i - 1, @entity.position.j - 1, 2, 2
	
	#game.Screen.add 'game', GameScreen
	#window.screen = game.Screen.screens.game
	
	$ ->
		return
		game.Loop.delta = 1.0 / 30
		game.Loop.start()