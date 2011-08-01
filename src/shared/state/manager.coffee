define [
	'shared/state/state'
], (State) ->
	{extend, defaults, isObject, isFunction} = _

	class StateManager
		focus:     false
		paused:    false
		pauseloop: true

		log: (log) ->
			console.log "#{@loop.tick.toFixed 2} [StateManager] #{log}"

		register: (@loop) ->
			@loop._update = @update.bind @
			@loop._leave  = @render.bind @

		constructor: ->
			@states  = {}
			@enabled = []
			@_active = {}

		forEach: (fn, iterateDisabled = false) ->
			for name, state of @states
				continue if not iterateDisabled and @enabled.indexOf(name) is -1
				fn.call fn, state, name

		pause: ->
			@log 'pausing'
			@paused = true
			@loop.pause() if @pauseloop is true
			@

		play: ->
			@log 'playing'
			@paused = false
			@loop.play() if @pauseloop is true
			@

		get: (name) ->
			@states[name] or false

		$: @::get

		isState:   (name) -> @get(name) isnt false
		isEnabled: (name) -> @enabled.indexOf(name) > -1

		add: (name, klass, options = {}) ->
			options = defaults options, enable: false, persistent: false
			if isFunction klass
				@log "added #{name}/#{klass.name}"
				state = new klass name, @
				if not state instanceof State
					console.log "state is not an instance of State"
					return false
			else
				methods = klass
				state   = new State name, @

				if isObject methods
					state.update = methods.update if isFunction methods.update
					state.render = methods.render if isFunction methods.render

			@states[name] = state
			state.persistent = options.persistent
			@enable(name) if options.enable

			@

		toggle: (disable, enable) ->
			@disable disable
			@enable  enable

		enable: (name) ->
			return if not @isState(name) or @isEnabled(name)
			state = @get name

			#if Array.isArray name then return @enable i for i in name
			#return false if not state or @_active[name]?
			#@_active[name] = state
			#debugger

			@enabled.push name
			state.event.fire 'focus'

			@

		disable: (name, remove = false) ->
			return if not @isState(name) or not @isEnabled(name)
			state = @get name

			state.tick = 0

			#delete @_active[name]
			#if remove is true
			#	setTimeout (=>
			#		console.log 'deleting state ' + name
			#		delete @states[name]
			#	), 1
			@enabled.splice @enabled.indexOf name, 1
			state.event.fire 'blur'

			@

		update: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.update @loop.delta, @loop.tick
				state.tick += @loop.delta
			return

		render: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.render()
			return
