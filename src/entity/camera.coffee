define [
	'collision/aabb'
	'client/input/keyboard'
	'client/input/mouse'
], (AABB, Keyboard, Mouse) ->
	{Vector} = Math
	
	###
	class Camera extends Entity
		constructor: (name, options)->
			super name, options
			
	###
	
	class CameraEdgeMove extends Behaviour
		speed: 10
		
		input: (kb, ms) ->
			if ms.position.i <= 0
				@entity.position.i -= @speed
			else if ms.position.i >= width
				@entity.position.i += @speed
			
			if ms.position.j <= 0
				@entity.position.j -= @speed
			else if ms.position.j >= height
				@entity.position.j += @speed
		
		
	
	class Camera extends Entity
		entity:  null
		origin: 'center'
		
		constructor: (bounds = [1024, 768]) ->
			@hw = (@w = bounds[0]) / 2
			@hh = (@h = bounds[1]) / 2
			
			@aabb     = new AABB null, {t:@hh, b:@hh, l:@hw, r:@hw}
			@position = new Vector
			
			@input = @input.bind @, Keyboard.instance(), Mouse.instance()
		
		EDGE_MOVE_DISTANCE = 200
		EDGE_MOVE_MAXSPEED = 2.5
		
		input: (kb, ms) ->
			speed = 2
			
			if kb.keys.shift
				EDGE_MOVE_MAXSPEED = 20
			else 
				EDGE_MOVE_MAXSPEED = 5
			
			if kb.keys.a
				@position.i -= speed
			else if kb.keys.d
				@position.i += speed
			
			if kb.keys.w
				@position.j -= speed
			else if kb.keys.s
				@position.j += speed
			
			if ms.position.i < EDGE_MOVE_DISTANCE
				move = -Math.remap(Math.abs(EDGE_MOVE_DISTANCE - ms.position.i),
					[0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED])
			else if ms.position.i > (@w - EDGE_MOVE_DISTANCE)
				move = Math.remap(Math.abs(EDGE_MOVE_DISTANCE - (@w - ms.position.i)),
					[0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED])
			else
				move = 0
			
			@position.i = @position.i + Math.min EDGE_MOVE_MAXSPEED, move
			
			if ms.position.j < EDGE_MOVE_DISTANCE
				move = -Math.remap(Math.abs(EDGE_MOVE_DISTANCE - ms.position.j),
					[0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED])
			else if ms.position.j > (@h - EDGE_MOVE_DISTANCE)
				move = Math.remap(Math.abs(EDGE_MOVE_DISTANCE - (@h - ms.position.j)),
					[0, EDGE_MOVE_DISTANCE], [0, EDGE_MOVE_MAXSPEED])
			else
				move = 0
			
			@position.j = @position.j + Math.min EDGE_MOVE_MAXSPEED, move
		
		update: (delta, tick) ->
			if @entity
				#@position.i = @entity.body.position.i
				#@position.j = @entity.body.position.j
				@position.i = @entity.body.position.i - (@w / 2)
				@position.j = @entity.body.position.j - (@h / 2)
				#@aabb.setPosition @entity.body.position
			else
				@input()
			
			if @origin is 'topleft'
				@aabb.setPosition Vector.add @position, new Vector @hw, @hh
			else if @origin is 'center'
				@aabb.setPosition @position
			
			#@position.i = @aabb.hW if @position.i < @aabb.hW
			#@position.i = 10000 - @aabb.hW if @position.i > 10000 - @aabb.hW
			
			#@position.j = @aabb.hH if @position.j < @aabb.hH
			#@position.j = 10000 - @aabb.hH if @position.j > 10000 - @aabb.hH
			
			#speed = if Game.Input.keyboard.shift then 32 else 16
		
		render: (canvas) ->
			#if @origin is 'topleft'
			#	pos = 
			#else if @origin is 'center'
				
			canvas.rectangle @position, [@aabb.w, @aabb.h], stroke: 'red', width: 5
		
		attach: (entity) ->
			@entity = entity
