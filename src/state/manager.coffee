define [
	'state/state'
], (State) ->
	{defaults, isArray, isObject, isFunction} = _

	class StateManager
		_sharedData = {}

		states:  null
		enabled: null

		focus:     false
		paused:    false
		pauseLoop: true

		setData: (key, value) ->
			_sharedData[key] = value

		getData: (key) ->
			_sharedData[key] or false

		log: (log) ->
			console.log "#{@loop.tick.toFixed 2} [StateManager] #{log}"

		register: (_loop) ->
			return if not isObject _loop
			_loop._enter  = @enter.bind @
			_loop._leave  = @leave.bind @
			_loop._update = @update.bind @
			@loop = _loop

		constructor: (_loop) ->
			@register _loop
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
			@loop.pause() if @pauseLoop
			@

		play: ->
			@log 'playing'
			@paused = false
			@loop.play() if @pauseLoop
			@

		get: (name) ->
			@states[name] or false

		$: @::get

		isState:    (name) -> @get(name) isnt false
		isEnabled:  (name) -> @enabled.indexOf(name) > -1
		isDisabled: (name) -> @enabled.indexOf(name) is -1

		addAll: (states = [], options = {}) ->
			for i in states
				continue if not (isFunction(i) and isObject(i))
				@add i.name.toLowerCase(), i, options
			@

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
