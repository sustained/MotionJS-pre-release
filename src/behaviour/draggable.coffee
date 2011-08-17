define [
	'behaviours/behaviour'
], (Behaviour) ->
	{Vector} = Math
	
	class Draggable extends Behaviour
		difference: null
		
		constructor: (parent, listener, options = {}) ->
			super parent, listener
		
		update: () ->
			if @parent.clicked
				@parent.body.gravity = @parent.body.collide = false
				
				#@difference = Vector.subtract globalgame.Input.mouse.position.game, @parent.body.position
				#@parent.body.position = @parent.body.position.add @difference
				@parent.body.position = globalgame.Input.mouse.position.game.clone()
			else
				@parent.body.gravity = @parent.body.collide = true
	
	Draggable