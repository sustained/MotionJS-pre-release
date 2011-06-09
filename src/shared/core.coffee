define [
	'shared/utilities/class'
	'shared/utilities/eventful'
	
	'shared/math/vector'
	'shared/math/matrix'
	'shared/math/random'
], (Class, Eventful, Vector, Matrix, Random) ->
	toString  = Object::toString
	isBrowser = window? and document? and navigator?
	root      = if isBrowser then window else global
	
	if not root.Motion?
		Motion = 
			READY:   false
			LOADED:  false
			VERSION: '0.1'
			
			# Commonly used Classes
			Class:    Class
			#Color:    Colour
			#Colour:   Colour
			Eventful: Eventful
			
			env:  if isBrowser then 'client' else 'server'
			root: root
		
		Motion.event = new Eventful ['dom', 'load'], binding: Motion
		
		if Motion.env is 'client'
			root.jQuery = $.noConflict()
			
			jQuery(document).ready -> Motion.READY  = true ; Motion.event.fire 'dom'
			jQuery(window).load    -> Motion.LOADED = true ; Motion.event.fire 'load'
		
			Motion.ready = (fn, bind) ->
				if Motion.READY then fn() else Motion.event.on 'dom', fn, bind: bind
			
			Motion.loaded = (fn, bind) ->
				if Motion.LOADED then fn() else Motion.event.on 'load', fn, bind: bind
		
		Motion.require = (modules, callback = ->) ->
			modules = [modules] if not Array.isArray modules
			require modules, -> callback Array::slice.call arguments
		
		#root.rgb  = (r, g, b)    -> new Colour r, g, b
		#root.rgba = (r, g, b, a) -> new Colour r, g, b, a
		
		#root.rand  = Random.integer
		#root.frand = Random.float
		
		###Colour.create 'white',       255, 255, 255
		Colour.create 'black',         0,   0,   0
		Colour.create 'red',         255,   0,   0
		Colour.create 'green',         0, 255,   0
		Colour.create 'blue',          0,   0, 255
		Colour.create 'yellow',      255, 255,   0###
		
		if not root.console?
			root.console = {}
			root.console[method] = -> null for method in '''
				assert count debug dir dirxml
				error group groupCollapsed groupEnd
				info log markTimeline profile
				profileEnd time timeEnd trace warn
			'''.split /\s+/
		
		console.log 'Motion defined'
		root.$M = root.Motion = Motion
	
	console.log 'Motion returned'
	root.Motion
