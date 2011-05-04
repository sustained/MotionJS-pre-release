define [
	'graphics/colour'
	
	'utilities/class'
	'utilities/eventful'
	
	'math/vector'
	'math/matrix'
	'math/random'
], (Colour, Class, Eventful, Vector, Matrix, Random) ->
	toString  = Object::toString
	isBrowser = window? and document? and navigator?
	root      = if isBrowser then window else global
	
	if not root.Motion?
		Motion = 
			READY:  false
			LOADED: false
			
			VERSION: '0.1'
			
			
			Class:    Class
			Color:    Colour
			Colour:   Colour
			Eventful: Eventful
			
			env: if isBrowser then 'client' else 'server'
			root: root
		
		Motion.event = new Eventful ['dom', 'load'], aliases: on, binding: Motion
		
		jQuery(document).ready -> Motion.READY  = true ; Motion.event.fire 'dom'
		jQuery(window).load    -> Motion.LOADED = true ; Motion.event.fire 'load'
		
		root.rgb  = (r, g, b)    -> new Colour r, g, b
		root.rgba = (r, g, b, a) -> new Colour r, g, b, a
		
		#root.rand  = Random.integer
		#root.frand = Random.float
		
		Colour.create 'white',       255, 255, 255
		Colour.create 'black',         0,   0,   0
		Colour.create 'red',         255,   0,   0
		Colour.create 'green',         0, 255,   0
		Colour.create 'blue',          0,   0, 255
		Colour.create 'yellow',      255, 255,   0
		
		if not root.console?
			root.console = {}
			for method in '''
				assert count debug dir dirxml
				error group groupCollapsed groupEnd
				info log markTimeline profile
				profileEnd time timeEnd trace warn
			'''.split /\s+/
				root.console[method] = -> null
		
		root.$M = root.Motion = Motion
	
	root.Motion
