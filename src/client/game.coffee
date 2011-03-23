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
				size: [1024, 768]
				delta: 1.0 / 60
			}, options
			
			@world      = new World [2000, 2000]
			@world.game = @
			
			if Motion.env is 'client'
				@Input    = new Input
				@Screen   = new MScreen @
				#@Graphics = new Graphics
			
			@Loop       = new Loop @
			@Loop.delta = options.delta
			
			@Event = new Eventful
			
			@canvas = new Canvas options.size
			@canvas.create()
			
			@Loop.context = @canvas.context
			@Input?.setup @canvas.$canvas
			
			__instance = @
		
		createWorld: (name, options) ->
			options = Motion.extend {
				size: [1024, 768]
			}, options
			
			@worlds[name] = new World options
		
		removeWorld: (name) ->
			delete @worlds[name]
	
	Game