define [
	'math/vector'
	'math/matrix'
	'math/random'
	
	'natives/hash'
	'natives/math'
	'natives/array'
	'natives/number'
	'natives/string'
], (Vector, Matrix, Random) ->
	toString  = Object::toString
	isBrowser = window? and document? and navigator?
	
	root = if isBrowser then window else global
	
	# There may only be one!
	return root.Motion if root.Motion?
	
	# Check types
	root.isA        = (object, klass) -> object? and object instanceof klass
	root.isArray    = Array.isArray ? (obj) -> toString.call(obj) is '[object Array]'
	root.isString   = (object) -> toString.call(object) is '[object String]'
	root.isObject   = (object) -> toString.call(object) is '[object Object]'
	root.isNumber   = (object) -> toString.call(object) is '[object Number]'
	root.isRegExp   = (object) -> toString.call(object) is '[object RegExp]'
	root.isFunction = (object) -> toString.call(object) is '[object Function]'
	root.isInfinite = (object) -> not isFinite object
	root.isVector   = (object) -> isA object, Math.Vector
	root.isMatrix   = (object) -> isA object, Math.Matrix
	
	# move this shit
	root.Logger = class Logger
		time: 0
		
		constructor: (delta) ->
			@delta = delta / 1000
		
		log: (args...) ->
			return if globalgame.Loop.tick - @time < @delta
			@time = globalgame.Loop.tick
			console.log args...
	
	Motion = root.$M = root.Motion = 
		env:     if isBrowser then 'client' else 'server'
		root:    root
		version: '0.1'
		
		# Extend an object
		extend: (object, mixin, overwrite = on) ->
			for k, v of mixin
				continue if overwrite is off and k of object
				object[k] = v
			object
		
		# Mix an object into a prototype.
		include: (klass, mixin, overwrite) ->
			Motion.extend klass::, mixin, overwrite
		
		# Merge two objects
		merge: (objA, objB, returnNew = false) ->
			obj = if returnNew then {} else objA
			
			for k of objB
				try
					obj[k] = if isObject objB[k] then Motion.merge objA[k], objB[k] else objB[k]
				catch e
					obj[k] = objB[k]
			
			obj
	
	Math.Vector = Vector
	Math.Matrix = Matrix
	Math.Random = Random
	
	if not root.console?
		root.console = {}
		for method in '''
			assert count debug dir dirxml
			error group groupCollapsed groupEnd
			info log markTimeline profile
			profileEnd time timeEnd trace warn
		'''.split /\s+/
			root.console[method] = -> null
	
	Motion