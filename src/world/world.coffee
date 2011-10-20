#
define ->
	{Vector} = Math

	class World
		_id = 0

		camera: null

		constructor: ->
			@id = _id++

			@cameras  = {}
			@entities = {}

			@types   = {}
			@classes = {}

			@bounds = [1024, 768]

			#@createCamera 'main'

		update: ->
		render: ->

		setCamera: (name) ->
			@camera = name if name of @cameras

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
