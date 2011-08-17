define ->
	isFunction = (object) -> object? and Object::toString.call(object) is '[object Function]'

	{isFunction}
