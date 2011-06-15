define [
	'shared/state'
], (State) ->
	{Class} = Motion

	class StateManager extends Class
		focus:     false
		paused:    false
		pauseloop: true
		
		register: ->
			@game.loop._onUpdate = @update.bind @
			@game.loop._onRender = @render.bind @
		
		constructor: () ->
			super()
			
			@game = require('client/game').instance()

			@states  = {}
			@enabled = []
			@_active = {}
		
		pause: ->
			console.log 'StateManager pausing'
			@paused = true
			@game.loop.pause() if @pauseloop is true
			@
		
		play: ->
			console.log 'StateManager resuming'
			@paused = false
			@game.loop.play() if @pauseloop is true
			@
		
		get: (name) ->
			@states[name] or false

		$: @::get
		
		isState: (name) -> @get(name) isnt false

		add: (name, state, options = {}) ->
			options = Object.extend {
				enable:     true
				persistent: false
			}, options

			if Function.isFunction state
				state = new state name#, @game
				return false if not state instanceof State
			else
				extend = state
				state  = new State name#, @game

				if Object.isObject extend
					state.update = extend.update if Function.isFunction extend.update
					state.render = extend.render if Function.isFunction extend.render
			
			#state.bind 'update', null, [@game.loop.delta]
			#state.bind 'render', null, [@game.loop.context]
			
			@states[name] = state
			state.persistent = options.persistent
			
			@enable(name) if options.enable
			
			@
		
		toggle: (disable, enable) ->
			@disable disable
			@enable  enable
		
		enable: (name) ->
			console.log @isState name
			return if not @isState name
			state = @get name
			return if state.active is true

			#if Array.isArray name then return @enable i for i in name
			#return false if not state or @_active[name]?
			#@_active[name] = state
			#debugger

			console.log @enabled.push name
			state.event.fire 'focus'

			@
		
		disable: (name, remove = false) ->
			return if not @isState name
			state = @get name
			return if state.active is false

			#if Array.isArray name then return @disable i, remove for i in name
			#return false if not state or not @_active[name]?

			state.tick = 0

			#delete @_active[name]
			#if remove is true
			#	setTimeout (=>
			#		console.log 'deleting state ' + name
			#		delete @states[name]
			#	), 1

			console.log @enabled = @enabled.remove name
			state.event.fire 'blur'
			#@enabled = @enabled.remove name
			#debugger
			@

		update: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.update  @game.loop.tick
				state.tick += @game.loop.delta
			return
		
		render: ->
			for name in @enabled
				state = @get name
				continue if @paused is true and state.persistent is false
				state.render()
			return
