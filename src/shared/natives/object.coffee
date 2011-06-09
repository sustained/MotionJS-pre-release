Object.isObject = (object) -> toString.call(object) is '[object Object]'

# Extend an object with another object
Object.extend = (objectA, objectB, overwrite = true) ->
	for key, val of objectB
		continue if overwrite is off and key of objectA
		objectA[key] = val
	
	objectA

# Extend a constructor's prototype with an object
Object.include = (klass, object, overwrite = false) ->
	Object.extend klass::, object, overwrite

Object.clone = (object) ->
	cloned = if Array.isArray(object) then [] else {}

	for k of object
		if Object.isObject object[k]
			cloned[k] = Object.clone object[k]
		else
			cloned[k] = object[k]
	
	cloned

# Merge b into a.
Object.merge = (a, b) ->
	merged = Object.clone a

	for k of b
		try
			merged[k] = if Object.isObject b[k] then Object.merge a[k], b[k] else b[k]
		catch e
			merged[k] = b[k]
	
	merged
