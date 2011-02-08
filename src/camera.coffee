camera = (Motion, Entity) ->
	class Camera extends Entity
		drawAABB:    off
		drawCorners: off
	
		constructor: ->
			@super()
		
			@position.set 0, 0
			@setDimensions 1024, 768
	
		getAABB: ->
			{
			
			}
	
		getCorners: ->
			{
			
			}
	
		render:        noop
		renderAABB:    noop
		renderCorners: noop
	
		update: (Game, t, dt) ->
			speed = if Game.Input.keyboard.shift then 256 else 64
		
			if Game.Input.isKeyDown 'left'
				@velocity.i = -speed
			else if Game.Input.isKeyDown 'right'
				@velocity.i = speed
			else
				@velocity.i = 0
		
			if Game.Input.isKeyDown 'up'
				@velocity.j = -speed
			else if Game.Input.isKeyDown 'down'
				@veocity.j = speed
			else
				@velocity.j = 0
		
			@updateVectors dt
	
		centerOn: (vector) ->
			@position.i = vector.i = @radius[0]
			@position.j = vector.j = @radius[1]

define ['motion', 'entity'], camera