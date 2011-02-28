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
		
		update: noop
		render: noop
	
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
		
		input:   noop
		damping: noop
		update:  noop
		render:  noop
	
	{Static, Dynamic}