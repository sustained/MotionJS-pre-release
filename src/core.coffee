define [
	'math/vector'
	'math/matrix'
	'math/random'
	'natives/hash'
	'natives/math'
	'natives/array'
	'natives/number'
	'natives/string'
], (Vector, Matrix, Random) ->
	toString  = Object::toString
	isBrowser = window? and document? and navigator?
	
	root = if isBrowser then window else global
	
	return root.Motion if root.Motion?
	
	Motion = root.$M = root.Motion = 
		env: if isBrowser then 'client' else 'server'
		root: root
		version: '0.1'
	
	Math.Vector = Vector
	Math.Matrix = Matrix
	Math.Random = Random
	
	# Extend an object
	ext = Motion.extend = (object, mixin, overwrite = on) ->
		for k, v of mixin
			continue if overwrite is off and k of object
			object[k] = v
		object
	
	# Mixin an object
	inc = Motion.include = (klass, mixin) ->
		Motion.extend klass::, mixin
	
	Motion.setup = (opts) ->
		opts = ext {
			
		}, opts
	
	# Check types
	root.isA        = (object, klass) -> object? and object instanceof klass
	root.isArray    = Array.isArray ? (obj) -> toString.call(obj) is '[object Array]'
	root.isString   = (object) -> toString.call(object) is '[object String]'
	root.isObject   = (object) -> toString.call(object) is '[object Object]'
	root.isNumber   = (object) -> toString.call(object) is '[object Number]'
	root.isRegExp   = (object) -> toString.call(object) is '[object RegExp]'
	root.isFunction = (object) -> toString.call(object) is '[object Function]'
	root.isInfinite = (object) -> not isFinite object
	root.isVector   = (object) -> isA object, Math.Vector
	root.isMatrix   = (object) -> isA object, Math.Matrix

	if not root.console?
		root.console = {}
		for method in '''
			assert count debug dir dirxml
			error group groupCollapsed groupEnd
			info log markTimeline profile
			profileEnd time timeEnd trace warn
		'''.split /\s+/
			root.console[method] = -> null

	Motion