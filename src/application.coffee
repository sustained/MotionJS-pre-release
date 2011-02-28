require [
	'motion'
	#'eventful'
	#'stateful'
	'loop'
	'input'
	'screenmanager'
	'screen'
	'canvas'
	'colour'
], (Motion, Loop, Input, MScreen, Screen, Canvas, Colour) ->
	class App extends Motion.Class
		constructor: ->
			super
			
			if Motion.env is 'client'
				@Input    = new Input
				#@Graphics = new MGraphics
				@Screen   = new MScreen @
			
			@Loop = new Loop @
			
		update: ->
			
		
		render: ->
			
		
	App