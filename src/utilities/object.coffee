define ->
	{isArray, isObject} = _

	clone = (object) ->
		cloned = if isArray(object) then [] else {}
		for k of object
			if isObject object[k]
				cloned[k] = clone object[k]
			else
				cloned[k] = object[k]
		cloned

	merge = (a, b) ->
		merged = clone a

		for k of b
			try
				merged[k] = if _.isObject b[k] then merge a[k], b[k] else b[k]
			catch e
				merged[k] = b[k]
		merged

	{clone, merge}
