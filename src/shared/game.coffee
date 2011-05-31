define [
	'fs'
	'path'
	'require'

	'core/loop'
], (fs, path, require, Loop) ->
	{Eventful} = Motion

	class Game
		_setup: ->
		_ready: ->

		constructor: (config = {}) ->
			url = config.url + 'motiongame.json'

			if path.exists url
				try
					console.log 'prop', config
					console.log 'json', json    = JSON.parse fs.readFileSync url
					console.log 'merg', @config = Object.merge json, config
				catch e
					console.error 'Error: Parsing motiongame.json failed'
					console.log e
			else
				console.log "Notice: No config file (at:#{url})"

			@setup @config.setup if @config.setup
			@ready @config.ready if @config.ready

			@loop  = new Loop @, delta: @config.delta
			@event = new Eventful ['setup', 'ready'], binding: @

			@event.on 'setup', -> @_setup()
			@event.on 'ready', -> @_ready()

			@event.add   'loadModules', limit: 2
			@event.after 'loadModules', -> Motion.ready => @event.fire 'ready'
			
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
			
			# ...
		
		setup: (fn = ->) -> @_setup = fn.bind @
		ready: (fn = ->) -> @_ready = fn.bind @
