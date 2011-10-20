#
define ->
	isString = (object) -> object? and Object::toString.call(object) is '[object String]'

	pad = (string, length, padding = ' ') ->
			string = "#{string}"
			string = padding + string while string.length < length
			string

	ord = (char) ->
		char.charCodeAt 0

	capitalize = (string) ->
		string = string.charAt(0).toUpperCase() + string.slice 1

	{isString, pad, ord, capitalize, capitalise: capitalize}
