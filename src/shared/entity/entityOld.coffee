define [
	'utilities/eventful'
	'dynamics/body'
], (Eventful, Body) ->
	_entityId = 0
	
	class Static
		body: null
		
		fill:   false
		stroke: false
		
		selected: false
		
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
		
		selected: false
		
		constructor: ->
			#@game = require 'client/game'
			
			@id = ++_entityId
			@body = new Body
			@body.static = false
			
			@event = new Eventful ['collision'], binding: @
			
			@collisions       = []
			@behaviours       = {}
			@activeBehaviours = []
		
		addBehaviour: (name, behaviour, opts = {}) ->
			opts = Motion.extend {
				active:   true
				parent:   @
				listener: @
			}, opts
			
			behaviour         = new behaviour opts.parent, opts.listener
			@behaviours[name] = behaviour
			
			@activeBehaviours.push(name) if opts.active is true
		
		getBehaviour: (name) ->
			@behaviours[name] or undefined
		
		removeBehaviour: (name) ->
			if name in @behaviours
				@behaviours = @behaviours.remove(name)
				
				true
			
			false
		
		input:   -> null
		damping: -> null
		
		update: ->
			for i in @activeBehaviours
				@behaviours[i].update()
		
		render: ->
			if @selected is true
				@body.aabb.render stroke:'blue'
			
			#for i in @activeBehaviours
			#	@behaviours[i].render
	
	{Static, Dynamic}