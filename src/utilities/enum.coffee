#
define ->
	class Enum
		constructor: (values) ->
			i = 0
			while i < values.length
				@[values[i].toUpperCase()] = ++i
