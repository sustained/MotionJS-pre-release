define [
	'class'
	'eventful'
	'stateful'
	'loop'
	'input'
	'canvas'
	'screenmanager'
	'dynamics/world'
], (Class, Eventful, Stateful, Loop, Input, Canvas, MScreen, World) ->
	__instance = null
	
	class Game extends Class
		constructor: (options) ->
			return __instance if __instance?
			
			super()
			
			options = Motion.extend {
				url:   ''
				size:  [1024, 768]
				delta: 1.0 / 60
			}, options
			
			@worlds = {}
			@createWorld 'default', options.size
			
			@input  = @Input    = new Input
			@screen = @Screen   = new MScreen @
			
			@loop = @Loop = new Loop @
			@loop.delta   = options.delta
			
			@event = @Event = new Eventful
			
			@canvas = new Canvas options.size
			@canvas.create()
			
			@loop.context = @canvas.context
			@input.setup @canvas.$canvas
			
			__instance = @
		
		createWorld: (name, options) ->
			@worlds[name]      = new World options
			@worlds[name].game = @
		
		getWorld: (name) ->
			@worlds[name]
		
		removeWorld: (name) ->
			delete @worlds[name]
	
	return if __instance then __instance else Game