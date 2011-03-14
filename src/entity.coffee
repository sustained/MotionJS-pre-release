define [
	'eventful'
	'physics/body'
], (Eventful, Body) ->
	_entityId = 0
	
	class Static
		body: null
		
		fill:   false
		stroke: false
		
		constructor: ->
			@id = ++_entityId
			@body = new Body
			@body.static = true
		
		update: -> null
		render: -> null
	
	class Dynamic
		body: null
		
		fill:   false
		stroke: false
		
		constructor: ->
			@id = ++_entityId
			@body = new Body
			
			@event = new Eventful ['collision'], binding: @
			
			@behaviours       = {}
			@activeBehaviours = []
		
		input:   -> null
		damping: -> null
		update:  -> null
		render:  -> null
	
	{Static, Dynamic}