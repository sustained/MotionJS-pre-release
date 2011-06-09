define [
	'fs'
	'path'
	'require'

	'shared/loop'
], (fs, path, require, Loop) ->
	{Eventful} = Motion

	class Game
		log: (log...) ->
			console.log "[Game]:"
			console.log i for i in log
		
		constructor: (options = {}) ->
			url = options.url + 'motiongame.json'

			@loop  = new Loop @, delta: options.delta
			@event = new Eventful ['setup', 'ready'], binding: @

			@setup options.setup if Function.isFunction options.setup
			@ready options.ready if Function.isFunction options.ready

			if path.exists url
				try
					json    = JSON.parse fs.readFileSync url
					@config = Object.merge json, options
				catch e
					console.error 'Error: Parsing motiongame.json failed'
					console.log e
			else
				console.log "Notice: No config file (at:#{url})"

			@log 'opts, json and config:'
			@log options, json, @config

			@event.add   'loadModules', limit: 2
			@event.after 'loadModules', ->
				@event.fire 'setup'
				Motion.ready (-> @event.fire 'ready'), @
			
			if @config.states
				states = @config.states.map (state) -> "game/states/#{state}"
				require states, (modules...) =>
					for state in modules
						@state.add state.name.toLowerCase(), state, enable: false
					@event.fire 'loadModules'
			
			if @config.entities
				entities = @config.entities.map (entity) -> "game/entities/#{entity}"
				require entities, (modules...) =>
					@entities = modules
					@event.fire 'loadModules'
		
		setup: (fn = ->) -> @event.on 'setup', fn
		ready: (fn = ->) -> @event.on 'ready', fn
