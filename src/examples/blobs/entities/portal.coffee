define [
	'entity'
	'geometry/polygon'
	'geometry/rectangle'
], (Entity, Polygon, Rectangle) ->
	class Portal extends Entity.Dynamic
		portal:  null
		lastUse: 0
	
		constructor: ->
			super
		
			@event.on 'collision', (collision, entity) ->
				if game.Loop.tick - @lastUse > 0.5
					@lastUse = game.Loop.tick
					entity.body.position.copy(@portal.body.position)

			@body.shape = Polygon.createRectangle 32, 32#new Rectangle(32)

		render: (context) ->
			@body.shape.draw context
	
	Portal