define ->
	resolveDotPath = (string, object) ->
		string   = string.split '.'
		resolved = object
		while (part = string.shift())?
			if resolved[part]? then resolved = resolved[part] else break
		resolved

	_padString = ' '
	pad = (string, length, padding = _padString) ->
		string = "#{string}"
		string = padding + string while string.length < length
		string

	ord = (char) ->
		char.charCodeAt 0

	capitalize = (string) ->
		string = string.charAt(0).toUpperCase() + string.slice 1

	obj = {resolveDotPath, pad, ord, ordinal:ord, capitalize}
	obj.__defineSetter__ 'PAD_STRING', (char) -> _padString = char
	obj
