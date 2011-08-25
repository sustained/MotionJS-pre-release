define [
	'state/state'
], (State) ->
	{extend, defaults, isObject, isFunction} = _

	class StateManager
		focus:     false
		paused:    false
		pauseloop: true

		log: (log) ->
			console.log "#{@loop.tick.toFixed 2} [StateManager] #{log}"

		register: (@loop) ->
			@loop._enter  = @enter.bind  @
			@loop._leave  = @leave.bind  @
			@loop._update = @update.bind @

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

		isState:    (name) -> @get(name) isnt false
		isEnabled:  (name) -> @enabled.indexOf(name) > -1
		isDisabled: (name) -> not @isEnabled name

		add: (name, klass, options = {}) ->
			options = defaults options, enable: false, persistent: false

			@log "adding #{name}/#{klass.name}"

			state = null

			if klass instanceof State
				state = klass
				state.name = name
				state.manager = @
			else if isFunction klass
				state = new klass name, @
				if not state instanceof State
					@log "state #{name}/#{klass.name} is not an instance of State"
					return false
			else if isObject klass
				state = new State name, @
				methods = klass

				state.update = methods.update if isFunction methods.update
				state.render = methods.render if isFunction methods.render
			
			return false if not state?

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
		
		enter: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.enter()

		update: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.update @loop.delta, @loop.tick
				state.tick += @loop.delta
			return

		leave: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.render()
			return