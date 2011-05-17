define ->
	{Vector} = Math
	
	class World
		_id = 0
		
		constructor: ->
			@id = _id++
			
			@cameras   = {}
			@entities  = {}
			
			@types   = {}
			@classes = {}
		
		update: ->
		
		render: ->
		
		createCamera: (name, size) ->
			@cameras[name] = new Camera size
		
		getEntityById: (id) ->
			@entities[id]
		
		getEntitiesByType: (type) ->
			@types[type]
		
		getEntitiesByClass: (klass) ->
			@classes[klass]
		
		addEntity: (entity) ->
			type  = entity.type
			klass = entity.constructor.name
			
			entity.world = @
			
			@types[type] = [] if not @types[type]
			@types[type].push entity.id
			
			@classes[klass] = [] if not @classes[klass]
			@classes[klass].push entity.id
			
			@entities[entity.id] = entity
			#@entityIds.push entity.id
		
		removeEntity: (id) ->
			if id of @entities
				#entity.destructor()
				delete @entities[id]
				
				true
			
			false
		
		randomV: -> new Vector @randomX(), @randomY()
		randomX: -> Math.rand 0, @bounds[0]
		randomY: -> Math.rand 0, @bounds[1]
