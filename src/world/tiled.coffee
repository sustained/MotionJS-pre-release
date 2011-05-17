define [
	'world/world'
], (World) ->
	class TiledWorld extends World
		layers: null
		
		constructor: (@size = [16000, 16000]) ->
			super
			
			@layers  = []
		
		update: (dt, t) ->
			for entity in @entities
				entity.update dt, t
			return
		
		render: (g) ->
			for layer in @layers
				layer.render g
			return
