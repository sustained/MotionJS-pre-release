define ->
	class Behaviour
		_beforeTick: -> undefined
		_duringTick: -> undefined
		_afterTick:  -> undefined
		
		active: true
		
		parent:   null
		listener: null
		
		enable: ->
			@update = =>
			@render = =>
		
		disable: ->
			@update = @render = -> undefined
		
		constructor: (@parent, @listener = @parent) ->
