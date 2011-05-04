define [
	'core/screen'
], (Screen) ->
	{Class} = Motion
	
	class ScreenManager extends Class
		focus:     true
		paused:    false
		autopause: true
		
		register: ->
			@game.loop._onUpdate = @update.bind @
			@game.loop._onRender = @render.bind @
		
		constructor: (@game) ->
			super()
			
			jQuery(window).focus =>
				@focus = true
				@unpause() if @autopause is true
			
			jQuery(window).blur =>
				@focus = false
				@pause() if @autopause is true
			
			@screens = {}
			@enabled = []
		
		pause: ->
			console.log 'ScreenManager paused'
			@paused = true
		
		unpause: ->
			console.log 'ScreenManager unpaused'
			@paused = false
		
		add: (name, screen, options = {}) ->
			options = Object.extend {
				enable:     false
				persistent: false
			}, options
			
			if Function.isFunction screen
				screen = new screen name, @game
				return false if not screen instanceof Screen
			else
				extend = screen
				screen = new Screen name, @game
			
				if Object.isObject extend
					if Function.isFunction extend.update
						screen.update = extend.update
					
					if Function.isFunction extend.render
						screen.render = extend.render
			
			screen.bind 'update', null, [@game.loop.delta]
			screen.bind 'render', null, [@game.loop.context]
			
			@screens[name] = screen
			
			if options.enable     is true then @enable name
			if options.persistent is true then @screens[name].persistent = true
			
			@
		
		toggle: (disable, enable) ->
			@disable disable
			@enable  enable
		
		enable: (name) ->
			if Array.isArray name
				@enable i for i in name
				return
			
			@screens[name].focus()
			@enabled.push name
			
			@
		
		disable: (name) ->
			if Array.isArray name
				@disable i for i in name
				return
			
			screen = @screens[name]
			
			return false if screen.persistent
			
			screen.tick = 0
			screen.blur()
			@enabled = @enabled.remove name
			
			@
		
		sort: ->
			@enabled = @enabled.sort (a, b) =>
				return if @screens[a].zIndex > @screens[b].zIndex then 1 else -1
		
		update: ->
			for name in @enabled
				screen = @screens[name]
				continue if @paused is true and screen.persistent is false
				screen.update @game.loop.tick
				screen.tick += @game.loop.delta
			return
		
		render: ->
			for name in @enabled
				screen = @screens[name]
				continue if @paused is true and screen.persistent is false
				screen.render.call()
			return
