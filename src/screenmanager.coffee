define [
	'class'
	'screen'
], (Class, Screen) ->
	class ScreenManager extends Class
		constructor: (@Game) ->
			super()
			
			@screens = {}
			@enabled = []
		
		add: (name, screen, enable = true) ->
			return false if not isFunction screen
			screen = new screen name, @Game
			return false if not screen instanceof Screen
			
			screen.bind 'update', null, [@Game.Loop.delta]
			screen.bind 'render', null, [@Game.Loop.context]
			
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
				@screens[name].update @Game.Loop.tick
				@screens[name].tick += @Game.Loop.delta
			null
		
		render: ->
			for name in @enabled
				@screens[name].render.call()
			null
	
	ScreenManager