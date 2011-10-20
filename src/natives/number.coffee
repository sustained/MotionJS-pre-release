#
define ->
	isNumber = (object) -> object? and Object::toString.call(object) is '[object Number]'

	chr = (number) -> String.fromCharCode number

	random = (number) -> Math.round Math.random() * number

	{isNumber, chr, random, rand: random}
