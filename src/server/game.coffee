define [
	'class'
	'eventful'
	'loop'
	'dynamics/world'
	
	'path'
], (Class, Eventful, Loop, World, path) ->
	__instance = null
	
	class Game extends Class
		constructor: (options) ->
			return __instance if __instance?
			
			super()
			
			@options = Motion.extend {
				path:  ''
				delta: 1.0 / 10
			}, options
			
			if @path = options.path
				@load()
			
			@loop = @Loop = new Loop @
			@loop.delta   = options.delta
			
			@event = @Event = new Eventful
			
			@worlds = {}
			@createWorld 'default'
			
			__instance = @
		
		createWorld: (name, options) ->
			options = Motion.extend {
				size: [1024, 768]
			}, options
			
			@worlds[name] = new World options
		
		getWorld: (name) ->
			@worlds[name]
		
		removeWorld: (name) ->
			delete @worlds[name]
		
		load: ->
			if path.existsSync @path
				entities = listFiles "#{@path}src/"
				console.log entities
	
	Game