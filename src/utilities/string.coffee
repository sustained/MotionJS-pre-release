define ->
	# Given a string - "foo.bar.baz", returns object['foo']['bar']['baz']
	resolveDotPath = (string, object) ->
		string   = string.split '.'
		resolved = object
		while (part = string.shift())?
			if resolved[part]? then resolved = resolved[part] else break
		resolved

	pad = (string, length, padding = ' ') ->
		string = "#{string}"
		string = padding + string while string.length < length
		string

	ord = (char) ->
		char.charCodeAt 0

	capitalize = (string) ->
		string = string.charAt(0).toUpperCase() + string.slice 1

	{resolveDotPath, pad, ord, ordinal:ord, capitalize}
