define [
	'class'
	'screen'
], (Class, Screen) ->
	class ScreenManager extends Class
		focus: true
		
		constructor: (@game) ->
			super()
			
			$(window).focus => @focus = true
			$(window).blur  => @focus = false
			
			@screens = {}
			@enabled = []
		
		add: (name, screen, enable = false) ->
			return null if not isFunction screen
			screen = new screen name, @game
			return false if not screen instanceof Screen
			
			screen.bind 'update', null, [@game.loop.delta]
			screen.bind 'render', null, [@game.loop.context]
			
			@screens[name] = screen
			
			if enable then @enable name
			
			@
		
		toggle: (disable, enable) ->
			@disable disable
			@enable  enable
		
		enable: (name) ->
			if isArray name
				@enable i for i in name
				return
			
			@screens[name].focus()
			@enabled.push name
			
			@
		
		disable: (name) ->
			if isArray name
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
				continue if @focus is false and screen.persistent is false
				@screens[name].update @game.Loop.tick
				@screens[name].tick += @game.Loop.delta
			return
		
		render: ->
			for name in @enabled
				screen = @screens[name]
				continue if @focus is false and screen.persistent is false
				@screens[name].render.call()
			return
