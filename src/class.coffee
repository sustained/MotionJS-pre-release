define ['classutils'], (ClassUtils) ->
	class BaseClass
		classId = 0
		
		id: null
		
		constructor: ->
			@id = classId++
		
		@extend:  (object, overwrite = no) -> Motion.extend @,   object, overwrite
		@include: (object, overwrite = no) -> Motion.extend @::, object, overwrite
		
		@extend ClassUtils.Ext.Accessors
		
		bind: (name, bind = @, args = []) ->
			@[name] = @[name].bind bind, args...
			@[name]
		
		# return the instance's class
		class: ->
			@constructor.name
		
		hash: ->
			"<Obj##{@class()}:#{@id}>"
		toString: @::hash
		
		# return a bound (by default) method
		method: (name, bind = yes) ->
			if @[name]
				return if bind is yes then @[name].bind @ else @[name]
			else
				return null
		
		methods: (opts) ->
			opts = extend {
				self: on
				bind: on
			}, opts
			methods = {}
			for k, v of @
				continue if not isFunction v
				
				if opts.self is on
					continue if k of @constructor.__super__
				else
					v = v.bind @ if opts.bind is on
				
				methods[k] = v
			
			methods
		
		respondTo: (method) ->
			method of @
		
		send: (method, args...) ->
			@[method].apply @, args
