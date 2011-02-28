define ['class', 'eventful'], (Class, Eventful) ->
	class Stateful extends Class
		constructor: (@Game) ->
			super()
			@Event   = new Eventful 'beforeUpdate', 'afterUpdate', 'beforeRender', 'afterRender'
			@states  = {}
			@enabled = {}
		
		isState: (name) ->
			return name of @states
		
		update: (Game, tick, delta) ->
			@Event.fire 'beforeUpdate', [Game, tick, delta]
			for state of @states
				continue if @enabled[state] is false and @states[state].continuous is off
				@states[state].update Game, tick, delta
			@Event.fire 'afterUpdate', [Game, tick, delta]
			return
		
		render: (Game, alpha, context) ->
			@Event.fire 'beforeRender', [Game, alpha, context]
			for state of @states
				continue if @enabled[state] is false and @states[state].continuous is off
				@states[state].render Game, alpha, context
			@Event.fire 'afterRender', [Game, alpha, context]
			return
		
		create: (name, state, enabled = false) ->
			return null if @isState name
			
			#if not isObject(state) or state.constructor.name isnt 'State'
			#	throw "Motion/Stateful: '#{name}' is not an instance of State"
			#	return
			
			state.name     = name
			@states[name]  = state
			@enabled[name] = enabled
			
			@states[name]
		
		remove: (name) ->
			if @isState name
				@disable name
				@states[name].Event.fire 'delete'
			@
		
		enable: (name) ->
			if @isState name
				@enabled[name] = yes
				@states[name].enableTime = @Game.Loop.time
				@states[name].Event.fire 'enable'
			@
		
		disable: (name) ->
			if @isState name and @states[name].continuous is false
				@enabled[name] = no
				@states[name].disableTime = @Game.Loop.time
				@states[name].Event.fire 'disable'
			@
	
	Stateful