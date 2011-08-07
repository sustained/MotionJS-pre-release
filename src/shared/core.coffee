define [
	'shared/natives/math'
	'shared/math/vector'
	'shared/math/matrix'
	'shared/math/random'
	'shared/utilities/eventful'
	'shared/utilities/class'
	'shared/utilities/string'
	'shared/utilities/object'
], (_Math, Vector, Matrix, Random, Event, Class, StrUtils, ObjUtils) ->
	console.log 'core'
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
