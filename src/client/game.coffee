define [
	'motion'
	'class'
	'eventful'
	'stateful'
	'loop'
	'input'
	'screenmanager'
], (Motion, Class, Eventful, Stateful, Loop, Input, MScreen) ->
	class Game extends Class
		_instance = null
		
		constructor: ->
			#if _instance isnt null then return _instance
			
			super()
			
			#@test = Math.random()
			
			if Motion.env is 'client'
				@Input  = new Input
				@Screen = new MScreen @
			
			@Loop  = new Loop @
			@Event = new Eventful
			
			#_instance = @
	
	Game