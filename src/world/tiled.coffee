define [
	'world/world'
], (World) ->
	class TiledWorld extends World
		layers: null
		
		constructor: ->
			super
			
			@layers = []
		
		update: (dt, t) ->
			for entity in @entities
				entity.update dt, t
			return
		
		render: (g) ->
			g.clearRect 0, 0, 1024, 768
			context.translate -@camera.position.i.round(), -@camera.position.j.round()
			world.render context, @camera
			@camera.render canvas
			context.translate @camera.position.i.round(), @camera.position.j.round()
