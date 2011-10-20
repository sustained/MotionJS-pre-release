define ->
	isObject = (object) -> object? and Object::toString.call(object) is '[object Object]'

	# Extend an object with another object
	extend = (objectA, objectB, overwrite = true) ->
		for key, val of objectB
			continue if overwrite is off and key of objectA
			objectA[key] = val
		
		objectA

	# Extend a constructor's prototype with an object
	include = (klass, object, overwrite = false) ->
		extend klass::, object, overwrite

	clone = (object) ->
		cloned = if Array.isArray(object) then [] else {}

		for k of object
			if isObject object[k]
				cloned[k] = clone object[k]
			else
				cloned[k] = object[k]
		
		cloned

	count = (object) ->
		count = 0
		count++ for k of object
		count

	# Merge b into a.
	merge = (a, b) ->
		merged = Object.clone a

		for k of b
			try
				merged[k] = if Object.isObject b[k] then Object.merge a[k], b[k] else b[k]
			catch e
				merged[k] = b[k]
		
		merged
	
	{isObject, extend, include, clone, count, merge}
