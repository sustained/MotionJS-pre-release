define [
	'utilities/eventful'
	'dynamics/body'
], (Eventful, Body) ->
	###
	#	
	###
	class Entity
		_id = 0
		
		name:  null
		group: null
		klass: null
		
		aabb: null
		
		hovered:  false
		clicked:  false
		selected: false
		
		constructor: (@world) ->
			@id    = _id++
			@group = 0
			@klass = @constructor.name
		
		input: (kb, ms, delta, tick) ->
			
		
		update: (delta, tick) ->
			@input tick
	
	class RigidBodyEntity extends Entity
		constructor: ->
			@body = new Body
	
	if Motion.env is 'client'
		Entity::render = ->
			@aabb.render
	
	Entity
