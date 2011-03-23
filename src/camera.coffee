define [
	'math/vector'
	'collision/aabb'
], (Vector, AABB) ->
	class Camera
		entity: null
		
		constructor: (bounds = [1024, 768]) ->
			@hw = (@w = bounds[0]) / 2
			@hh = (@h = bounds[1]) / 2
			
			@aabb     = new AABB null, {t:@hh, b:@hh, l:@hw, r:@hw}
			@position = new Vector
		
		update: (delta) ->
			if @entity
				@position.i = @entity.body.x - (@w / 2)
				@position.j = @entity.body.y - (@h / 2)
				@aabb.setPosition @entity.body.position
				return
			
			#@position.i = @aabb.hW if @position.i < @aabb.hW
			#@position.i = 10000 - @aabb.hW if @position.i > 10000 - @aabb.hW
			
			#@position.j = @aabb.hH if @position.j < @aabb.hH
			#@position.j = 10000 - @aabb.hH if @position.j > 10000 - @aabb.hH
			
			#speed = if Game.Input.keyboard.shift then 32 else 16
			
			###
			if Game.Input.isKeyDown 'left'
				@velocity.i += speed
			else if Game.Input.isKeyDown 'right'
				@velocity.i -= speed
			else
				if @velocity.i.abs() > 0.00005
					@velocity.i *= 0.8
				else
					@velocity.i = 0
		
			if Game.Input.isKeyDown 'up'
				@velocity.j += speed
			else if Game.Input.isKeyDown 'down'
				@velocity.j -= speed
			else
				if @velocity.j.abs() > 0.00005
					@velocity.j *= 0.8
				else
					@velocity.j = 0
		
			@updateVectors dt
			###
		
		render: (canvas) ->
			canvas.rectangle @aabb.position.clone(), [@aabb.w, @aabb.h], mode: 'center', stroke: 'red', width: 5
		
		attach: (entity) ->
			@entity = entity
	
	Camera
