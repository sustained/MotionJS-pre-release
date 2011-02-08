define ['motion', 'screen'], (Motion, Screen) ->
	class ScreenManager extends Motion.Class
		constructor: (@Game) ->
			super()
			
			@screens = {}
			@enabled = []
		
		add: (name, screen, enable = true) ->
			return false if not isFunction screen
			screen = new screen name, @Game
			return false if not screen instanceof Screen
			
			screen.bind 'update', @Game, @Game.Loop.delta
			screen.bind 'render', @Game, @Game.Loop.context
			
			@screens[name] = screen
			
			if enable
				@enabled.push name
			
			@
		
		enable: (name) ->
			if isArray name
				@enable i for i in name
				return
			
			@enabled.push name
			
			@
		
		disable: (name) ->
			if isArray name
				@disable i for i in name
				return
			
			return false if @screens[name].persistent is true
			
			@screens[name].tick = 0
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
				@screens[name].render @Game.Loop.alpha
			null
	
	ScreenManager