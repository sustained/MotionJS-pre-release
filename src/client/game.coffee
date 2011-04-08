define [
	'class'
	'eventful'
	'stateful'
	'loop'
	'input'
	'canvas'
	'screenmanager'
	'dynamics/world'
	'client/input/keyboard'
	'client/input/mouse'
], (Class, Eventful, Stateful, Loop, Input, Canvas, MScreen, World, Keyboard, Mouse) ->
	_instance = null
	
	class Game extends Class
		@instance: ->
			return if _instance then _instance else new @
		
		constructor: (options) ->
			return _instance if _instance?
			
			super()
			
			options = Motion.extend {
				url:   ''
				size:  [1024, 768]
				delta: 1.0 / 60
			}, options
			
			@worlds = {}
			@createWorld 'default', options.size
			
			@input  = @Input    = new Input # needs deprecating
			@screen = @Screen   = new MScreen @
			
			# if not a touch device...
			@mouse    = new Mouse
			@keyboard = new Keyboard
			# else
			
			@loop = @Loop = new Loop @
			@loop.delta   = options.delta
			
			@event = @Event = new Eventful
			
			@canvas = new Canvas options.size
			@canvas.create()
			
			@loop.context = @canvas.context
			@input.setup @canvas.$canvas
			
			_instance = @
		
		createWorld: (name, options) ->
			@worlds[name]      = new World options
			@worlds[name].game = @
		
		getWorld: (name) ->
			@worlds[name]
		
		removeWorld: (name) ->
			delete @worlds[name]
