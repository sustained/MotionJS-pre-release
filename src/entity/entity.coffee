define ->
	class Entity
		_entityId = 0
		
		name:  null
		group: null
		klass: null
		
		aabb: null
		
		hovered:  false
		clicked:  false
		selected: false
		
		constructor: (@world) ->
			@id    = _entityId++
			@group = 0
			@klass = @constructor.name
	
