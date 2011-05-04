define ->
	# Check types
	root.isA        = (object, klass) -> object? and object instanceof klass
	root.isString   = (object) -> toString.call(object) is '[object String]'
	root.isObject   = (object) -> toString.call(object) is '[object Object]'
	root.isNumber   = (object) -> toString.call(object) is '[object Number]'
	root.isRegExp   = (object) -> toString.call(object) is '[object RegExp]'
	root.isFunction = (object) -> toString.call(object) is '[object Function]'
	root.isInfinite = (object) -> not isFinite object
	root.isVector   = (object) -> isA object, Math.Vector
	root.isMatrix   = (object) -> isA object, Math.Matrix
	
	# Extend an object
	extend = (object, mixin, overwrite = on) ->
		for k, v of mixin
			continue if overwrite is off and k of object
			object[k] = v
		object

	# Mix an object into a prototype.
	include = (klass, mixin, overwrite) ->
		extend klass::, mixin, overwrite

	# Merge two objects
	merge = (objA, objB, returnNew = false) ->
		obj = if returnNew then {} else objA
		
		for k of objB
			try
				obj[k] = if isObject objB[k] then merge objA[k], objB[k] else objB[k]
			catch e
				obj[k] = objB[k]
		
		obj
	
	{extend, include, merge}
