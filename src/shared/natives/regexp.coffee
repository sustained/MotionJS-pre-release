define ->
	isRegExp = (object) -> object? and Object::toString.call(object) is '[object RegExp]'

	{isRegExp}
