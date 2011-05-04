define ->
	{Vector} = Math
	
	class World
		_id = 0
		
		constructor: (@bounds = [100000, 100000]) ->
			@id = _id++
			
			@w = @bounds[0]
			@h = @bounds[1]
			
			@groups = 
				player:  {}
				static:  {}
				dynamic: {}
			
			@cameras  = {}
			@entities = {}
			@entityIds = []
			
			@types   = {}
			@classes = {}
		
		update: ->
			
		
		render: ->
			
		
		createCamera: (name, size) ->
			camera = new Camera
		
		getEntityById: (id) ->
			@entities[id] ? false
		
		getEntitiesByType: (type) ->
			@types[type]
		
		getEntitiesByClass: (klass) ->
			@classes[klass]
		
		addEntity: (entity) ->
			type  = entity.collideType
			klass = entity.constructor.name
			
			entity.world = @
			
			if not @types[type]    then @types[type]    = []
			if not @classes[klass] then @classes[klass] = []
			
			@types[type].push    entity.id
			@classes[klass].push entity.id
			
			@entities[entity.id] = entity
			@entityIds.push entity.id
		
		removeEntity: (id) ->
			if id of @entities
				#entity.destructor()
				delete @entities[id]
				
				true
			
			false
		
		randomV: -> new Vector @randomX(), @randomY()
		randomX: -> Math.rand 0, @bounds[0]
		randomY: -> Math.rand 0, @bounds[1]
