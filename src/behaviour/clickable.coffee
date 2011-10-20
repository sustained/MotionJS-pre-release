define [
	'behaviour/behaviour'
], (Behaviour) ->
	###
		parent   is an AABB
		listener is an Entity
	###
	class Clickable extends Behaviour
		highlight: false
		
		constructor: (parent, listener, options = {}) ->
			super parent, listener
			
			@parent.hovered = 
			@parent.clicked = false
			
			@aabb = @parent.body.aabb
		
		update: () ->
			@parent.hovered = @parent.clicked = false
			
			if @aabb.containsPoint globalgame.Input.mouse.position.game
				@parent.hovered = true
				@listener.hover()
				
				if globalgame.Input.mouse.left
					@parent.clicked = true
					@listener.click()
				
	
	Clickable
