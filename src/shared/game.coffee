define [
	'fs'
	'path'
	'require'
], (fs, path, require) ->
	{Eventful} = Motion

	class Game
		_instance = null ; @instance: (options) -> _instance ? new @ options

		_defaultOptions =
			url:   null
			delta: 1.0 / 60

		log: (log...) ->
			console.log "[Game]:"
			console.log i for i in log
		
		constructor: (options = {}) ->
			console.log @config = Object.merge _defaultOptions, options
			@event = new Eventful ['setup', 'ready'], binding: @

			@event.on 'setup', options.setup if Function.isFunction options.setup
			@event.on 'ready', options.ready if Function.isFunction options.ready

			if @config.url
				configUrl = @config.url + 'motiongame.json' # path.join options.url, ...

				if path.exists configUrl
					try
						json    = JSON.parse fs.readFileSync configUrl
						@config = Object.merge json, options
					catch e
						console.error 'Error: Parsing motiongame.json failed'
						console.log e
				else
					console.log "Notice: No motionconfig.json file (at:#{@config.url})"

			@event.add 'loadModules', limit: 2
			#@event.on 'loadModules', (loaded) ->
			#	console.log 'loadModules loaded', loaded
			@event.after 'loadModules', ->
				@event.fire 'setup'
				Motion.ready (-> @event.fire 'ready'), @
			
			if @config.states
				states = @config.states.map (state) -> "app/states/#{state}"
				require states, (modules...) =>
					for state in modules
						@state.add state.name.toLowerCase(), state, enable: false
					@event.fire 'loadModules'
			
			if @config.entities
				entities = @config.entities.map (entity) -> "app/entities/#{entity}"
				require entities, (modules...) =>
					@entities = modules
					@event.fire 'loadModules'
		
		setup: (fn = ->) -> @event.on 'setup', fn
		ready: (fn = ->) -> @event.on 'ready', fn
