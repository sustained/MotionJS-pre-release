Object.isObject = (object) -> toString.call(object) is '[object Object]'

# Extend an object
Object.extend = (object, mixin, overwrite = true) ->
	for key, val of mixin
		continue if overwrite is off and key of object
		object[key] = val
	
	object

# Mix an object into a prototype.
Object.include = (klass, mixin, overwrite = false) ->
	Object.extend klass::, mixin, overwrite

# Merge two objects
Object.merge = (objA, objB, returnNew = false) ->
	obj = if returnNew then {} else objA
	
	for k of objB
		try
			obj[k] = if Object.isObject objB[k]
				Object.merge objA[k], objB[k]
			else
				objB[k]
		catch e
			obj[k] = objB[k]
	
	obj
