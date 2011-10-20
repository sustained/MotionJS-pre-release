#
define [
	'utilities/classutils'
], (ClassUtils) ->
	{extend} = _

	class BaseClass
		@Utils: ClassUtils

		_classId = 0

		id: null

		constructor: ->
			@id = _classId++

		@extend:  (object, overwrite = no) -> extend  @, object, overwrite
		#@include: (object, overwrite = no) -> include @, object, overwrite

		bind: (name, bind = @, args = []) ->
			@[name] = @[name].bind bind, args...
			@[name]

		method: (name) ->
			@[name].bind @

		parent: ->
			@__super__?.constructor.name

		class: ->
			@constructor.name

		hash: ->
			"[#{@class()}##{@id}]"
		toString: @::hash

	BaseClass
