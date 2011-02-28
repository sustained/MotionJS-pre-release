define ->
	toString  = Object::toString
	isBrowser = window? and document? and navigator?
	
	root = if isBrowser then window else global
	root.noop = -> null
	
	# Some useful functions for checking types
	root.isString   = (obj) -> toString.call(obj) is '[object String]'
	root.isObject   = (obj) -> toString.call(obj) is '[object Object]'
	root.isNumber   = (obj) -> toString.call(obj) is '[object Number]'
	root.isRegExp   = (obj) -> toString.call(obj) is '[object RegExp]'
	root.isFunction = (obj) -> toString.call(obj) is '[object Function]'
	root.isArray    = Array.isArray ? (obj) -> toString.call(obj) is '[object Array]'
	root.isInfinite = (obj) -> not isFinite obj

	# Extend an object
	root.extend = (object, mixin, overwrite = on) ->
		for k, v of mixin
			continue if overwrite is off and k of object
			object[k] = v
		object

	# Mixin an object
	root.include = (klass, mixin) ->
		extend klass::, mixin

	if not root.console?
		root.console = {}
		for method in '''
			assert count debug dir dirxml
			error group groupCollapsed groupEnd
			info log markTimeline profile
			profileEnd time timeEnd trace warn
		'''.split /\s+/
			root.console[method] = noop
	
	42