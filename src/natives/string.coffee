String.isString = (object) -> toString.call(object) is '[object String]'

String.ord = (char) ->
	char.charCodeAt 0

String.capital = (string) ->
	string = string.charAt(0).toUpperCase() + string.slice 1
