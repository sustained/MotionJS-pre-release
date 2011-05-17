define [
	'core/state'
], (State) ->
	{Class} = Motion
	
	class StateManager extends Class
		focus:     false
		paused:    false
		autopause: true
		pauseloop: true
		
		register: ->
			console.log 'registering'

			for name, state of @states
				state.bind 'update', null, [@game.loop.delta]
				state.bind 'render', null, [@game.canvas.context]
			
			@game.loop._onUpdate = @update.bind @
			@game.loop._onRender = @render.bind @
		
		constructor: (@game) ->
			super()
			
			if Motion.env is 'client'
				jQuery(window).focus =>
					return if @focus is true
					@focus = true
					@play() if @autopause is true
				
				jQuery(window).blur =>
					@focus = false
					@pause() if @autopause is true
			
			@states  = {}
			@enabled = []
		
		pause: ->
			console.log 'paused'
			@paused = true
			@game.loop.pause() if @pauseloop is true
			
			@
		
		play: ->
			console.log 'unpaused'
			@paused = false
			@game.loop.play() if @pauseloop is true
			
			@
		
		get: (name) -> @states[name]

		$: @::get
		
		add: (name, state, options = {}) ->
			options = Object.extend {
				enable:     false
				persistent: false
			}, options
			
			if Function.isFunction state
				state = new state name, @game
				return false if not state instanceof State
			else
				extend = state
				state  = new State name, @game
			
				if Object.isObject extend
					state.update = extend.update if Function.isFunction extend.update
					state.render = extend.render if Function.isFunction extend.render
			
			#state.bind 'update', null, [@game.loop.delta]
			#state.bind 'render', null, [@game.loop.context]
			
			@states[name] = state
			@states[name].persistent = options.persistent
			
			if options.enable is true then @enable name
			
			@
		
		toggle: (disable, enable) ->
			@disable disable
			@enable  enable
		
		enable: (name) ->
			if Array.isArray name
				@enable i for i in name
				return
			
			state = @get name
			state.event.fire 'focus'

			@enabled.push name
			@
		
		disable: (name, remove = false) ->
			if Array.isArray name then return @disable i, remove for i in name

			state = @get name
			return if state.persistent is true

			state.tick = 0
			state.event.fire 'blur'

			@enabled = @enabled.remove name
			@
		
		sort: ->
			@enabled = @enabled.sort (a, b) =>
				return if @states[a].zIndex > @states[b].zIndex then 1 else -1
			
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
