define [
	'natives/math'
	'math/vector'
	'math/matrix'
	'math/random'
	'utilities/eventful'
	'utilities/class'
	'utilities/string'
	'utilities/object'
], (_Math, Vector, Matrix, Random, Event, Class, StrUtils, ObjUtils) ->
	{clone, isObject} = _

	toString  = Object::toString
	isBrowser = window? and document? and navigator?
	root      = if isBrowser then window else global

	return root.Motion if root.Motion?

	root.Math[k] = v for k,v of _Math
	root.Math[k] = v for k,v of {Vector, Matrix, Random}

	Motion  = {
		Event, Class

		Utils: {String:StrUtils, Object:ObjUtils}
		READY:   false
		LOADED:  false
		VERSION: '0.1'

		env:  if isBrowser then 'client' else 'server'
		root: root
	}

	#Motion.event = new Eventful ['dom', 'load'], binding: Motion

	_prefixes = ['webkit', 'moz', 'o', 'ms']

	root.requestAnimFrame = (->
		if root.requestAnimationFrame?
			return root.requestAnimationFrame
		postfix = 'RequestAnimationFrame'
		_prefixes.unshift 'request'
		for i in _prefixes
			return root[i+postfix] if root[i+postfix]?
		return (callback, element) -> root.setTimeout callback, 1000 / 60
	)()

	root.cancelAnimFrame = (->
		if root.cancelAnimationFrame?
			return root.cancelAnimationFrame handle.value
		postfix = 'CancelRequestAnimationFrame'
		for i in _prefixes
			return root[i+postfix] if root[i+postfix]?
		return clearInterval
	)()

	if Motion.env is 'client'
		jQuery(document).ready -> Motion.READY  = true
		jQuery(window).load    -> Motion.LOADED = true

	if not root.console?
		root.console = {}
		root.console[method] = -> null for method in '''
			assert count debug dir dirxml
			error group groupCollapsed groupEnd
			info log markTimeline profile
			profileEnd time timeEnd trace warn
		'''.split /\s+/

	root.Motion = Motion
