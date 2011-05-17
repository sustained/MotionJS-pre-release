define [
	'fs'
	'path'
	'require'

	'core/loop'
	'core/statemanager'
	'core/state'
], (fs, path, require, Loop, StateManager, State) ->
	{Eventful} = Motion

	class Game
		_setup: null
		_ready: null

		constructor: (url, @config = {}) ->
			if path.exists url + 'motiongame.json'
				try
					config  = JSON.parse fs.readFileSync url + 'motiongame.json'
					@config = Object.merge @config, config
				catch e
					console.log 'Error: Parsing motiongame.json failed'
			else
				console.log "Notice: Configuration not found (at:#{url}motiongame.json)"

			console.log @config

			@loop  = new Loop @, delta: @config.delta
			@state = new StateManager @
			@event = new Eventful ['setup', 'ready'], binding: @

			@event.on 'setup', @config.setup if @config.setup
			@event.on 'ready', @config.ready if @config.ready
			
			@event.add   'loadModules', limit: 2
			@event.after 'loadModules', ->
				console.log 'loaded modules'
				@event.fire 'setup'

				Motion.ready =>
					console.log 'game ready function'
					@event.fire 'ready'

			if @config.states
				states = @config.states.map (state) -> "game/states/#{state}"

				require states, (modules...) =>
					console.log modules
					@state.add state.name.toLowerCase(), state for state in modules
					@event.fire 'loadModules'
			
			if @config.entities
 				entities = @config.entities.map (entity) -> "game/entities/#{entity}"
 				
				require entities, (modules...) =>
					console.log modules
					@entities = modules
					@event.fire 'loadModules'
		
		setup: (fn = ->) -> @_setup = fn.bind @
		ready: (fn = ->) -> @_ready = fn.bind @
