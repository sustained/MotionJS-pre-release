define [
	'motion'
	'class'
	'eventful'
	'loop'
	'input'
	'screenmanager'
], (Motion, Class, Eventful, Loop, Input, MScreen) ->
	class Application extends Class
		constructor: ->
			super()
			
			if Motion.env is 'client'
				@Input  = new Input
				@Screen = new MScreen @
			
			@Loop  = new Loop @
			@Event = new Eventful
	
	Application