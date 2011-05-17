define [
	'utilities/classutils'
], (ClassUtils) ->
	class BaseClass
		@Utils: ClassUtils
		
		classId = 0
		
		id: null
		
		constructor: ->
			@id = classId++
		
		@extend:  (object, overwrite = no) -> Object.extend  @, object, overwrite
		@include: (object, overwrite = no) -> Object.include @, object, overwrite
		
		bind: (name, bind = @, args = []) ->
			@[name] = @[name].bind bind, args...
			@[name]
		
		parent: ->
			@__super__?.constructor.name
		
		class: ->
			@constructor.name
		
		hash: ->
			"#{@class()}##{@id}"
		toString: @::hash
	
	BaseClass
