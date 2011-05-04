define [
	'core/loop'
	'core/screenmanager'
	
	'assets/asset'
	'assets/image'
	#'assets/audio'
	#'assets/video'
	
	'graphics/canvas'
	'graphics/tileset'
	
	'client/input/keyboard'
	'client/input/mouse'
	
	'dynamics/world'
], (Loop, MScreen, Asset, Image, Canvas, TileSet, Keyboard, Mouse, World) ->
	{Class, Eventful} = Motion
	
	class Game extends Class
		_setup    = false
		_instance = null
		
		@instance: ->
			return if _instance then _instance else new @
		
		options: null
		
		setup: (options = {}) ->
			return if _setup is true
			
			@options = Object.extend {
				url:   ''
				size:  [1024, 768]
				delta: 1.0 / 60
			}, options
			
			_setup = true
		
		constructor: (options) ->
			return _instance if _instance?
			
			super()
			
			@setup options
			
			@worlds = {}
			@createWorld 'default', options.size
			
			@loop   = new Loop @, delta: options.delta
			#@input  = new Input # needs deprecating
			@screen = @scene = new MScreen @
			
			if @options.url.length > 0
				Asset.setUrl @options.url + 'assets/'
				
				Image.setUrl null, true
				#Audio.setUrl null, true
				#Video.setUrl null, true
			
			# if not a touch device...
			@mouse    = new Mouse
			@keyboard = new Keyboard
			# else
			
			
			@event = new Eventful ['ready'], binding: @
			
			@event.on 'ready', ->
				if @mouse    then @mouse.setup()
				if @touch    then @touch.setup()
				if @keyboard then @keyboard.setup()
			
			Motion.event.on 'load', => @event.fire 'ready'
			
			@canvas = new Canvas options.size
			@canvas.create()
			
			@loop.context = @canvas.context
			#@input.setup @canvas.$canvas
			
			_instance = @
		
		createWorld: (name, options) ->
			@worlds[name]      = new World options
			@worlds[name].game = @
		
		getWorld: (name) ->
			@worlds[name]
		
		removeWorld: (name) ->
			delete @worlds[name]
