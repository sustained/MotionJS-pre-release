define [
	'math/vector'
	'collision/aabb'
], (Vector, AABB) ->
	class Camera
		entity:  null
		origin: 'center'
		
		constructor: (bounds = [1024, 768]) ->
			@hw = (@w = bounds[0]) / 2
			@hh = (@h = bounds[1]) / 2
			
			@aabb     = new AABB null, {t:@hh, b:@hh, l:@hw, r:@hw}
			@position = new Vector
		
		update: (delta) ->
			speed = 2
			
			if @entity
				@position.i = @entity.body.x - (@w / 2)
				@position.j = @entity.body.y - (@h / 2)
				@aabb.setPosition @entity.body.position
			else
				if game.Input.isKeyDown 'left'
					@position.i -= speed
				else if game.Input.isKeyDown 'right'
					@position.i += speed
				
				if game.Input.isKeyDown 'up'
					@position.j -= speed
				else if game.Input.isKeyDown 'down'
					@position.j += speed
				
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
				
			canvas.rectangle @position.clone(), [@aabb.w, @aabb.h], stroke: 'red', width: 5
		
		attach: (entity) ->
			@entity = entity
	
	Camera
